import RxSwift
import RxAlamofire

struct SignInResponse {
    let token: String
    let userId: String
}

extension AppService: AuthServiceType {

    func signIn(_ username: String, _ password: String) -> Single<SignInResponse> {
        return Single<SignInResponse>.create { single in
            // call to backend
            //single(.success(SignInResponse(token: "12345", userId: "5678")))
            do {
                try self.store.userDefaults.removeValue(forKey: StoreKey.authToken.rawValue)
            } catch let error {
                print(error.localizedDescription)
            }
            single(.error(NSError.init(domain: "Could Not Authenticate", code: 0, userInfo: nil)))
            return Disposables.create()
        }
    }
}
