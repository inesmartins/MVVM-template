import RxFlow
import UIKit

class DDGSearchFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController()
    private let services: DDGServiceType

    init(withServices services: DDGServiceType) {
        self.services = services
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }

}

extension DDGSearchFlow {

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .searchIsRequired:
            return self.navigationToSearchScreen()
        case .showSearchResults(let searchTerm):
            return self.navigationToSearchResultsScreen(withSearchTerm: searchTerm)
        default:
            return .none
        }
    }

}

private extension DDGSearchFlow {

    func navigationToSearchScreen() -> FlowContributors {
        let viewController = DDGSearchViewController.instantiate(withViewModel: DDGSearchViewModel(), andServices: self.services)
        viewController.title = "Search on DDG"
        self.rootViewController.pushViewController(viewController, animated: true)
        self.rootViewController.view.backgroundColor = .white
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController.viewModel))
    }

    func navigationToSearchResultsScreen(withSearchTerm searchTerm: String) -> FlowContributors {
        let viewController = DDGSearchResultsViewController
            .instantiate(withViewModel: DDGSearchResultsViewModel(searchTerm: searchTerm), andServices: self.services)
        viewController.title = viewController.viewModel.searchTerm
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewController.viewModel))
    }
}
