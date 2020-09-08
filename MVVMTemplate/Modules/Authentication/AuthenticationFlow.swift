import RxFlow

class AppFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController()
    private let apiService: APIService
    private let store: Store

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? DemoStep else { return .none }
        switch step {
        case.loginIsRequired:
            return self.navigateToAuthenticationScreen()
        case .userIsLoggedIn:
            return self.navigateToHomeScreen()
        default:
            return .none
        }
    }

    private func navigateToAuthenticationScreen() -> FlowContributors {
        let viewController = WatchedViewController.instantiate(withViewModel: WatchedViewModel(),
                                                               andServices: self.services)
        viewController.title = "Watched"

        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController.viewModel))
    }

    private func navigateToHomeScreen () -> FlowContributors {
        let viewController = MovieDetailViewController.instantiate(withViewModel: MovieDetailViewModel(withMovieId: movieId),
                                                                   andServices: self.services)
        viewController.title = viewController.viewModel.title
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController.viewModel))
    }

}
