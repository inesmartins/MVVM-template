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
            return self.navigateToCountryListScreen()
        case .countryIsPicked(let name):
            return self.navigateToCountryDetailScreen(withName: name)
        default:
            return .none
        }
    }

}

private extension CountryListFlow {

    func navigateToCountryListScreen() -> FlowContributors {
        let viewController = CountryListViewController.instantiate(withViewModel: CountryListViewModel(), andServices: self.services)
        viewController.title = "Country List"
        self.rootViewController.pushViewController(viewController, animated: true)
        self.rootViewController.view.backgroundColor = .white
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController.viewModel))

    }

    func navigateToCountryDetailScreen(withName name: String) -> FlowContributors {
        let viewController = CountryDetailViewController
            .instantiate(withViewModel: CountryDetailViewModel(name: name), andServices: self.services)
        viewController.title = viewController.viewModel.name
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewController.viewModel))
    }

}
