import RxFlow
import RxSwift
import RxCocoa

protocol AuthViewModelType {
    func validateLogin()
}

class AuthViewModel: ServicesViewModel, Stepper {

    let steps = PublishRelay<Step>()
    typealias Services = AuthServices
    var services: Services!

    var username = BehaviorSubject<String>(value: "")
    var password = BehaviorSubject<String>(value: "")
    var isValid: Observable<Bool> {
        return Observable.combineLatest(self.username.asObservable(), self.password.asObservable()) { (username, password) in
            return !username.isEmpty && !password.isEmpty
        }
    }

}

extension AuthViewModel: AuthViewModelType {

    func validateLogin() {
        do {
            let username = try self.username.value()
            let pwd = try self.password.value()
            self.services.authService.validateLogin(username, pwd, onCompletion: { success in
                if success {
                    self.steps.accept(AppStep.userIsAuthenticated)
                }
            })
        } catch let error {
            print(error)
        }
    }

}
