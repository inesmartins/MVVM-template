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
        let countryListFlow = CountryListFlow(withServices: self.services)
        Flows.use(countryListFlow, when: .created) { [unowned self] (root1: UINavigationController) in
            let tabBarItem1 = UITabBarItem(title: "Country List", image: UIImage(named: "wishlist"), selectedImage: nil)
            root1.tabBarItem = tabBarItem1
            root1.title = "Country List"
            self.rootViewController.setViewControllers([root1], animated: false)
        }

        return .multiple(flowContributors: [
            .contribute(withNextPresentable: countryListFlow, withNextStepper: OneStepper(withSingleStep: AppStep.countryListIsRequired))
        ])
    }
}
