import Foundation
import UIKit
import RxFlow

class AuthFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    let rootViewController = UITabBarController()
    private let api: APIServiceType
    private let store: StoreServiceType
    
    init(withServices api: APIServiceType, withStore store: StoreServiceType) {
        self.api = api
        self.store = store
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .loginIsRequired:
            return navigateToAuth()
        default:
            return .none
        }
    }
    
}

extension AuthFlow {

    func navigateToAuth() -> FlowContributors {
        let authStepper = AuthStepper(withServices: self.api, withStore: self.store)
        let authFlow = AuthFlow(withServices: self.api)

        Flows.use(authStepper, when: .created) { navCtrl in
            self.rootViewController.setViewControllers(navCtrl, animated: false)
        }
        return .one(flowContributor: .contribute(withNextPresentable: authFlow,
                                                 withNextStepper: OneStepper(withSingleStep: AppStep.loginIsRequired)))
    }
}
