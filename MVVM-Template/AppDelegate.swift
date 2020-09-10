import UIKit
import RxFlow
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var coordinator = FlowCoordinator()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow()

        let services = AppServices(session: Session.default)
        let appFlow = AppFlow(services: services)
        let appStepper = AppStepper(withServices: services)
        self.coordinator.coordinate(flow: appFlow, with: appStepper)

        Flows.use(appFlow, when: .created) { root in
            self.window?.rootViewController = root
            self.window?.makeKeyAndVisible()
        }

        UNUserNotificationCenter.current().delegate = self
        return true
    }

}

extension AppDelegate {

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.init(arrayLiteral: [.alert, .badge]))
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        self.coordinator.navigate(to: AppStep.countryWasPicked(withName: "Portugal"))
    }
}
