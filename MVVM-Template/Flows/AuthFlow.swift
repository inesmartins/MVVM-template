import Foundation
import UIKit.UINavigationController
import RxFlow

class AuthFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.navigationBar.topItem?.title = "Authentication"
        return viewController
    }()

    private let services: AppService

    init(withServices services: AppService) {
        self.services = services
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }
}

extension AuthFlow {

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }

        switch step {
        case .authenticationRequired:
            return navigationToLoginScreen()
        case .userIsAuthenticated:
            return .end(forwardToParentFlowWithStep: AppStep.userIsAuthenticated)
        default:
            return .none
        }
    }

}

private extension AuthFlow {

    func navigationToLoginScreen() -> FlowContributors {
        let authViewController = AuthViewController.instantiate(withViewModel: AuthViewModel(),
                                                                andServices: self.services)
        authViewController.title = "Login"
        self.rootViewController.pushViewController(authViewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: authViewController,
                                                 withNextStepper: authViewController.viewModel))
    }

}
