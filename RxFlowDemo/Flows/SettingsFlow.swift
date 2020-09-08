//
//  SettingsFlow.swift
//  RxFlowDemo
//
//  Created by Thibault Wittemberg on 17-08-09.
//  Copyright (c) RxSwiftCommunity. All rights reserved.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa

class SettingsFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UISplitViewController()
    private let settingsStepper: SettingsStepper
    private let services: AppServices

    init(withServices services: AppServices, andStepper stepper: SettingsStepper) {
        self.settingsStepper = stepper
        self.services = services
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }

        switch step {
        case .settingsAreRequired:
            return navigateToSettingsScreen()
        case .loginIsRequired:
            return navigateToLoginScreen()
        case .userIsLoggedIn:
            return popToMasterViewController()
        case .aboutIsRequired:
            return navigateToAboutScreen()
        case .settingsAreComplete:
            return .end(forwardToParentFlowWithStep: AppStep.settingsAreComplete)
        case let .alert(message):
            return navigateToAlertScreen(message: message)
        default:
            return .none
        }
    }

    private func navigateToAlertScreen(message: String) -> FlowContributors {
        let alert = UIAlertController(title: "Demo", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Cancel", style: .cancel))
        rootViewController.present(alert, animated: true)
        return .none
    }

    private func popToMasterViewController() -> FlowContributors {
        if let navigationController = self.rootViewController.viewControllers[0] as? UINavigationController {
            navigationController.popToRootViewController(animated: true)
        }
        return .none
    }

    private func navigateToSettingsScreen() -> FlowContributors {
        let navigationController = UINavigationController()
        let settingsListViewController = SettingsListViewController.instantiate()
        let authViewController = AuthViewController.instantiate()

        self.rootViewController.viewControllers = [navigationController, authViewController]
        self.rootViewController.preferredDisplayMode = .allVisible

        authViewController.title = "Login"

        navigationController.viewControllers = [settingsListViewController]
        if let navigationBarItem = navigationController.navigationBar.items?[0] {
            let settingsButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                                 target: self.settingsStepper,
                                                 action: #selector(SettingsStepper.settingsDone))
            navigationBarItem.setRightBarButton(settingsButton, animated: false)
        }

        return .multiple(flowContributors: [
            .contribute(withNext: settingsListViewController),
            .contribute(withNext: authViewController),
            .forwardToCurrentFlow(withStep: AppStep.alert("Demo of multiple Flow Contributor"))
        ])
    }

    private func navigateToLoginScreen() -> FlowContributors {
        let settingsLoginViewController = AuthViewController.instantiate()
        settingsLoginViewController.title = "Login"
        self.rootViewController.showDetailViewController(settingsLoginViewController, sender: nil)
        return .one(flowContributor: .contribute(withNext: settingsLoginViewController))
    }

    private func navigateToAboutScreen() -> FlowContributors {
        let settingsAboutViewController = SettingsAboutViewController.instantiate()
        settingsAboutViewController.title = "About"
        self.rootViewController.showDetailViewController(settingsAboutViewController, sender: nil)
        return .none
    }

}

class SettingsStepper: Stepper {

    let steps = PublishRelay<Step>()

    var initialStep: Step {
        return AppStep.settingsAreRequired
    }

    @objc func settingsDone() {
        self.steps.accept(AppStep.settingsAreComplete)
    }
}
