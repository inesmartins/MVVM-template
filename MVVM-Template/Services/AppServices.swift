import RxRelay
import RxSwift
import Alamofire

protocol AuthServiceType {
    func signIn(_ username: String, _ password: String) -> Single<SignInResponse>
}

protocol CountryServiceType {
    func allCountries() -> [Country]
    func country(withName name: String) -> Country?
}

protocol DDGServiceType {
    func search(withParams: SearchParams) -> Single<SearchResult>
}

final class AppServices {

    internal let ddgEndpoint = "https://api.duckduckgo.com/"
    internal let session: Session

    init(session: Session) {
        self.session = session
    }

}

extension AppServices: ReactiveCompatible {}
extension Reactive where Base: AppServices {

    var isAuthenticated: Observable<Bool> {
        return UserDefaults.standard
            .rx
            .observe(Bool.self, AppKey.authToken.rawValue)
            .map { $0 ?? false }
    }
}
