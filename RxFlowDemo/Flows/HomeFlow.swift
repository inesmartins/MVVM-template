import Foundation
import UIKit
import RxFlow

class HomeFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    let rootViewController = UITabBarController()
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
        case .homeIsRequired:
            return navigateToHome()
        default:
            return .none
        }
    }

    private func navigateToHome() -> FlowContributors {
        let wishlistStepper = WishlistStepper()

        let countryListFlow = CountryListFlow(withServices: self.services)
        let wishListFlow = WishlistFlow(withServices: self.services, andStepper: wishlistStepper)
        let watchedFlow = WatchedFlow(withServices: self.services)

        Flows.use(countryListFlow, wishListFlow, watchedFlow, when: .created) { [unowned self] (root1: UINavigationController, root2: UINavigationController, root3: UINavigationController) in
            let tabBarItem1 = UITabBarItem(title: "Country List", image: UIImage(), selectedImage: nil)
            let tabBarItem2 = UITabBarItem(title: "Wishlist", image: UIImage(named: "wishlist"), selectedImage: nil)
            let tabBarItem3 = UITabBarItem(title: "Watched", image: UIImage(named: "watched"), selectedImage: nil)
            root1.tabBarItem = tabBarItem1
            root1.title = "Country List"
            root2.tabBarItem = tabBarItem2
            root2.title = "Wishlist"
            root3.tabBarItem = tabBarItem3
            root3.title = "Watched"
            self.rootViewController.setViewControllers([root1, root2, root3], animated: false)
        }

        return .multiple(flowContributors: [
            .contribute(withNextPresentable: countryListFlow, withNextStepper: OneStepper(withSingleStep: AppStep.countryListIsRequired)),
            .contribute(withNextPresentable: wishListFlow, withNextStepper: CompositeStepper(steppers: [OneStepper(withSingleStep: AppStep.moviesAreRequired), wishlistStepper])),
            .contribute(withNextPresentable: watchedFlow, withNextStepper: OneStepper(withSingleStep: AppStep.moviesAreRequired))])
    }
}
