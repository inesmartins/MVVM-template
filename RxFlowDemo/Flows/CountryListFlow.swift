import RxFlow
import UIKit

class CountryListFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController()
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

        case .countryListIsRequired:
            return navigateToCountryListScreen()
        default:
            return .none
        }
    }

    private func navigateToCountryListScreen() -> FlowContributors {
        let viewController = CountryListViewController.instantiate(withViewModel: CountryListViewModel(), andServices: self.services)
        viewController.title = "Country List"
        self.rootViewController.pushViewController(viewController, animated: true)
        self.rootViewController.view.backgroundColor = .white
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController.viewModel))

    }

}
