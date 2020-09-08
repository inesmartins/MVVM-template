//
//  HomeController.swift
import UIKit
import RxSwift

final class HomeCoordinator: ReactiveCoordinator<Void> {
    
    let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    override func start() -> Observable<Void> {
        let viewController = self.rootViewController as! HomeViewController
        let viewModel = HomeViewModel()
        viewController.viewModel = viewModel
        return Observable.never()
    }
    
}
