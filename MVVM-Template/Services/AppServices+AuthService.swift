import RxSwift
import RxAlamofire

extension AppServices: AuthServiceType {

    func signIn(_ username: String, _ password: String) -> Single<SignInResponse> {

        let testInstance = SignInResponse(token: UUID().uuidString, userId: UUID().uuidString)
        UserDefaults.standard.set(testInstance.token, forKey: AppKey.authToken.rawValue)

        return Single<SignInResponse>.create { single in
            self.session.rx.request(.get, self.ddgEndpoint)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: ["text/json"])
                .responseJSON()
                .observeOn(MainScheduler.instance)
                .subscribe {
                    if let error = $0.error {
                        //UserDefaults.standard.removeObject(forKey: AppKey.authToken.rawValue)
                        //single(.error(error))
                        print(error)
                        single(.success(testInstance))
                    }
                    guard let data = $0.element?.data,
                        let signInData = data.to(type: SignInResponse.self) else {
                        //UserDefaults.standard.removeObject(forKey: AppKey.authToken.rawValue)
                        //single(.error(NSError(domain: "Unable to get SignInResponse", code: 0, userInfo: nil)))
                        single(.success(testInstance))
                        return
                    }
                    UserDefaults.standard.set(signInData.token, forKey: AppKey.authToken.rawValue)
                    single(.success(signInData))
                }
        }
    }
}
