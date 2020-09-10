import RxFlow
import RxSwift
import RxCocoa

protocol AuthViewModelType {
    func validateLogin()
}

class AuthViewModel: ServicesViewModel, Stepper {

    private let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    typealias Services = AuthServiceType
    var services: Services!

    var username = BehaviorSubject<String>(value: "")
    var password = BehaviorSubject<String>(value: "")
    let didFailSignIn = PublishSubject<Error>()

    var isValid: Observable<Bool> {
        return Observable.combineLatest(self.username.asObservable(),
                                        self.password.asObservable()) { (username, password) in
            return !username.isEmpty && !password.isEmpty
        }
    }

}

extension AuthViewModel: AuthViewModelType {

    func validateLogin() {
        do {
            let username = try self.username.value()
            let pwd = try self.password.value()
            self.services.signIn(username, pwd)
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { [weak self] session in
                    self?.steps.accept(AppStep.userIsAuthenticated(withId: session.userId))
                }, onError: { [weak self] error in
                    self?.didFailSignIn.onNext(error)
                })
                .disposed(by: self.disposeBag)
        } catch let error {
            self.didFailSignIn.onNext(error)
        }
    }

}
