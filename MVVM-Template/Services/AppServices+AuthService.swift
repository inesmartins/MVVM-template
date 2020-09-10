import RxSwift
import RxAlamofire

extension AppServices: AuthServiceType {

    func signIn(_ username: String, _ password: String) -> Single<SignInResponse> {
        return self.performGetRequest(endpoint: self.authEndpoint)
    }
}
