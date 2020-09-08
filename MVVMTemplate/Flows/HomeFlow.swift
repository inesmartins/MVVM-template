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
        guard let step = step as? AppStep else { return .none }

        switch step {
        case .userIsLoggedIn:
            return navigateToHome()
        default:
            return .none
        }
    }

    func navigateToHome() -> FlowContributors {
        let wishlistStepper = HomeStepper(withServices: self.api, withStore: self.store)

        let wishListFlow = HomeFlow(withServices: self.services, andStepper: wishlistStepper)
        let watchedFlow = HomeFlow(withServices: self.api)

        Flows.use(wishListFlow, watchedFlow, when: .created) { [unowned self] (root1: UINavigationController, root2: UINavigationController) in
            let tabBarItem1 = UITabBarItem(title: "Wishlist", image: UIImage(named: "wishlist"), selectedImage: nil)
            let tabBarItem2 = UITabBarItem(title: "Watched", image: UIImage(named: "watched"), selectedImage: nil)
            root1.tabBarItem = tabBarItem1
            root1.title = "Wishlist"
            root2.tabBarItem = tabBarItem2
            root2.title = "Watched"

            self.rootViewController.setViewControllers([root1, root2], animated: false)
        }

        return .multiple(flowContributors: [.contribute(withNextPresentable: wishListFlow,
                                                        withNextStepper: CompositeStepper(steppers: [OneStepper(withSingleStep: AppStep.moviesAreRequired), wishlistStepper])),
                                            .contribute(withNextPresentable: watchedFlow,
                                                        withNextStepper: OneStepper(withSingleStep: AppStep.moviesAreRequired))])
    }
}
