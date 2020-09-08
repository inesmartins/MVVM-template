import Foundation
import UIKit
import RxFlow
import RxCocoa
import RxSwift

protocol AppFlowType {
    var root: Presentable { get }
    func navigate(to step: Step) -> FlowContributors
}

final class AppFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()

    private let api: APIServiceType
    private let store: StoreServiceType

    init(withServices api: APIServiceType, withStore store: StoreServiceType) {
        self.api = api
        self.store = store
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }

}

extension AppFlow: AppFlowType {
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }

        switch step {
        case .loginIsRequired:
            return navigationToAuthScreen()
        case .logoutIsRequired:
            return navigationToAuthScreen()
        case .userIsLoggedIn:
            return navigationToHomeScreen()
        default:
            return .none
        }
    }

}
private extension AppFlow {
    
    func navigationToAuthScreen() -> FlowContributors {
        let authFlow = AuthFlow(withServices: self.api, withStore: self.store)
        Flows.use(authFlow, when: .created) { [unowned self] root in
            self.rootViewController.pushViewController(root, animated: false)
        }
        return .one(flowContributor: .contribute(withNextPresentable: authFlow,
                                                 withNextStepper: OneStepper(withSingleStep: AppStep.dashboardIsRequired)))
    }

    func navigationToHomeScreen() -> FlowContributors {
        let homeStepper = HomeStepper(withServices: self.api, withStore: self.store)
        let homeFlow = HomeFlow(withServices: self.api, store: self.store)

        Flows.use(homeFlow, when: .created) { navCtrl in
            self.rootViewController.setViewControllers(navCtrl, animated: false)
        }
        return .one(flowContributor: .contribute(withNextPresentable: homeFlow,
                                                 withNextStepper: OneStepper(withSingleStep: AppStep.userIsLoggedIn)))
    }
}
