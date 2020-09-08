import UIKit
import RxFlow
import RxSwift
import RxCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    let disposeBag = DisposeBag()
    var window: UIWindow?
    var coordinator = FlowCoordinator()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow()

        let api = APIService()
        let store = StoreService(coreData: CoreDataStorage(),
                                 userDefaults: UserDefaultsStorage(),
                                 keychain: KeyChainStorage())

        let appFlow = AppFlow(withServices: api, withStore: store)
        let appStepper = AppStepper(withServices: api, withStore: store)
        self.configureCoordinator(flow: appFlow, stepper: appStepper, api: api, store: store)
        Flows.whenReady(flow1: appFlow, block: { root in
            self.window?.rootViewController = root
            self.window?.makeKeyAndVisible()
        })

        UNUserNotificationCenter.current().delegate = self

        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.init(arrayLiteral: [.alert, .badge]))
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // example of how DeepLink can be handled
        //self.coordinator.navigate(to: AppStep.countryIsSelected(withName: "Portugal"))
    }
}

private extension AppDelegate {
    
    func configureCoordinator(flow: Flow, stepper: Stepper, api: APIServiceType, store: StoreServiceType) {
        self.coordinator.rx.willNavigate.subscribe(onNext: { (flow, step) in
            print("will navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        self.coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            print("did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        self.coordinator.coordinate(flow: flow, with: stepper)
    }
}
