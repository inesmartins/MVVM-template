import Foundation
import RxSwift
import RxFlow
import RxRelay

class AuthViewModel: Stepper {

    let steps = PublishRelay<Step>()
    private let api: APIServiceType
    private let store: StoreServiceType
    private let disposeBag = DisposeBag()

    var username = PublishSubject<String?>()
    var password = PublishSubject<String?>()

    init(withServices api: APIServiceType, withStore store: StoreServiceType) {
        self.api = api
        self.store = store
    }

    var initialStep: Step {
        return AppStep.userIsLoggedIn
    }

}
