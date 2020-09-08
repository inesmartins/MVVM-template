import Foundation
import RxSwift
import RxFlow
import RxRelay

class HomeViewModel: Stepper {

    let steps = PublishRelay<Step>()
    private let api: APIServiceType
    private let store: StoreServiceType
    private let disposeBag = DisposeBag()

    init(withServices api: APIServiceType, withStore store: StoreServiceType) {
        self.api = api
        self.store = store
    }

    var initialStep: Step {
        return AppStep.userIsLoggedIn
    }

}
