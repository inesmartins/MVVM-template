import RxSwift
import RxAlamofire

struct SignInResponse {
    let token: String
    let userId: String
}

extension AppServices: AuthServiceType {

    func signIn(_ username: String, _ password: String) -> Single<SignInResponse> {
        return Single<SignInResponse>.create { single in
            // call to backend
            //single(.success(SignInResponse(token: "12345", userId: "5678")))
            UserDefaults.standard.removeObject(forKey: StoreKey.authToken.rawValue)
            single(.error(NSError.init(domain: "Could Not Authenticate", code: 0, userInfo: nil)))
            return Disposables.create()
        }
    }
}
