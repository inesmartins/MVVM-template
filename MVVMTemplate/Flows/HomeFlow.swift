import Foundation
import UIKit
import RxFlow

class HomeFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    let rootViewController = UITabBarController()
    private let api: APIServiceType
    private let store: StoreServiceType

    init(withServices api: APIServiceType, store: StoreServiceType) {
        self.api = api
        self.store = store
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
}

extension HomeFlow {

    func navigate(to step: Step) -> FlowContributors {
        switch step {
        default:
            return .none
        }
    }
}
