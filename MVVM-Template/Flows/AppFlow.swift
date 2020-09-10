import Foundation
import UIKit
import RxFlow
import RxCocoa
import RxSwift

class AppFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()

    private let services: AppService

    init(services: AppService) {
        self.services = services
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }

}

extension AppFlow {

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }

        switch step {
        case .homeIsRequired:
            return navigationToHomeScreen()
        case .authenticationRequired:
            return navigationToAuthScreen()
        case .userIsAuthenticated:
            return self.dismissAuthScreen()
        default:
            return .none
        }
    }

}

private extension AppFlow {

    func navigationToHomeScreen() -> FlowContributors {
        let homeFlow = HomeFlow(withServices: self.services)
        Flows.use(homeFlow, when: .created) { [unowned self] root in
            self.rootViewController.pushViewController(root, animated: false)
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: homeFlow,
            withNextStepper: OneStepper(withSingleStep: AppStep.homeIsRequired)))
    }

    func navigationToAuthScreen() -> FlowContributors {
        let onboardingFlow = AuthFlow(withServices: self.services)
        Flows.use(onboardingFlow, when: .created) { [unowned self] root in
            DispatchQueue.main.async {
                root.modalPresentationStyle = .currentContext
                self.rootViewController.present(root, animated: true)
            }
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: onboardingFlow,
            withNextStepper: OneStepper(withSingleStep: AppStep.authenticationRequired)))
    }

    func dismissAuthScreen() -> FlowContributors {
        if let authViewController = self.rootViewController.presentedViewController {
            authViewController.dismiss(animated: true)
        }
        return .none
    }
}

class AppStepper: Stepper {

    let steps = PublishRelay<Step>()
    private let appServices: AppService
    private let disposeBag = DisposeBag()

    init(withServices services: AppService) {
        self.appServices = services
    }

    var initialStep: Step {
        return AppStep.homeIsRequired
    }

    /// callback used to emit steps once the FlowCoordinator is ready to listen to them to contribute to the Flow
    func readyToEmitSteps() {
        self.appServices.rx
            .isOnboarded
            .map { $0 ? AppStep.userIsAuthenticated : AppStep.authenticationRequired }
            .bind(to: self.steps)
            .disposed(by: self.disposeBag)
    }
}
