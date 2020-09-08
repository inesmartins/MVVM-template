import UIKit
import RxFlow
import RxSwift
import RxCocoa

struct AppServices: HasPreferencesService, HasCountriesService {
    let preferencesService: PreferencesService
    let countriesService: CountriesService
    let store: StoreServiceType
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    let disposeBag = DisposeBag()
    var window: UIWindow?
    var coordinator = FlowCoordinator()

    lazy var appServices: AppServices = {
        let store = StoreService(coreData: CoreDataStorage(),
                                 userDefaults: UserDefaultsStorage(),
                                 keychain: KeyChainStorage())
        return AppServices(preferencesService: PreferencesService(),
                           countriesService: CountriesService(),
                           store: store)
    }()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        guard let window = self.window else { return false }

        let appFlow = AppFlow(services: self.appServices)
        let appStepper = AppStepper(withServices: self.appServices)
        self.configureCoordinator(flow: appFlow, stepper: appStepper)

        Flows.use(appFlow, when: .created) { root in
            window.rootViewController = root
            window.makeKeyAndVisible()
        }

        UNUserNotificationCenter.current().delegate = self
        return true
    }

}

extension AppDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.init(arrayLiteral: [.alert, .badge]))
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        self.coordinator.navigate(to: AppStep.countryIsPicked(withName: "Portugal"))
    }
}

private extension AppDelegate {

    func configureCoordinator(flow: Flow, stepper: Stepper) {
        self.coordinator.rx.willNavigate.subscribe(onNext: { (flow, step) in
            print("will navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        self.coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            print("did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        self.coordinator.coordinate(flow: flow, with: stepper)
    }

}
