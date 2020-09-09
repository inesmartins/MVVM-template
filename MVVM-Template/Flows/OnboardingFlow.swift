import Foundation
import UIKit.UINavigationController
import RxFlow

class AuthFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.navigationBar.topItem?.title = "OnBoarding"
        return viewController
    }()

    private let services: AppServices

    init(withServices services: AppServices) {
        self.services = services
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }

        switch step {
        case .loginIsRequired:
            return navigationToLoginScreen()
        case .userIsLoggedIn:
            return .end(forwardToParentFlowWithStep: AppStep.onboardingIsComplete)
        default:
            return .none
        }
    }

    private func navigationToLoginScreen() -> FlowContributors {
        let authViewController = AuthViewController.instantiate()
        authViewController.title = "Login"
        self.rootViewController.pushViewController(authViewController, animated: false)
        return .one(flowContributor: .contribute(withNext: authViewController))
    }

}
