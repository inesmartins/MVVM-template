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
        case .loginIsRequired, .logoutIsRequired:
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
        let authVC = AuthViewController(viewModel: AuthViewModel(withServices: self.api, withStore: self.store))
        self.rootViewController.pushViewController(authVC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: authVC, withNextStepper: authVC.viewModel))
    }

    func navigationToHomeScreen() -> FlowContributors {
        let homeFlow = HomeFlow(withServices: self.api, store: self.store)
        Flows.whenReady(flow1: homeFlow, block: { root in
            self.rootViewController.pushViewController(root, animated: false)
        })
        return .one(flowContributor: .contribute(withNextPresentable: homeFlow,
                                                 withNextStepper: OneStepper(withSingleStep: AppStep.userIsLoggedIn)))
    }
}

class AppStepper: Stepper {

    let steps = PublishRelay<Step>()
    private let api: APIServiceType
    private let store: StoreServiceType
    private let disposeBag = DisposeBag()

    init(withServices api: APIServiceType, withStore store: StoreServiceType) {
        self.api = api
        self.store = store
    }

    var initialStep: Step {
        return AppStep.loginIsRequired
    }

}
