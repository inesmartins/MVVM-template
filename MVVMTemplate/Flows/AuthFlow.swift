import Foundation
import UIKit
import RxFlow

class AuthFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    let rootViewController: AuthViewController
    private let api: APIServiceType
    private let store: StoreServiceType
    
    init(withServices api: APIServiceType, withStore store: StoreServiceType) {
        self.api = api
        self.store = store
        self.rootViewController = AuthViewController(viewModel: AuthViewModel(authService: api))
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .loginIsRequired, .logoutIsRequired:
            // TODO: implement
            return .none
        default:
            return .none
        }
    }
    
}
