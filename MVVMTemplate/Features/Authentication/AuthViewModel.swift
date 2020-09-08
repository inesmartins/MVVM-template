import Foundation
import RxSwift
import RxFlow
import RxRelay

class AuthViewModel: Stepper {

    private let disposeBag = DisposeBag()
    private let authService: AuthServiceType
    
    var steps = PublishRelay<Step>()
    var username = PublishSubject<String?>()
    var password = PublishSubject<String?>()
    
    init(authService: AuthServiceType) {
        self.authService = authService
    }
}
