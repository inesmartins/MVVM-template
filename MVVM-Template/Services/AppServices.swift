import RxRelay
import RxSwift

protocol AuthServiceType {
    func signIn(_ username: String, _ password: String) -> Single<SignInResponse>
}

protocol CountryServiceType {
    func allCountries() -> [Country]
    func country(withName name: String) -> Country?
}

protocol DDGServiceType {
    func search(withParams: SearchParams, onCompletion: @escaping (Result<SearchResult?, Error>) -> Void)
}

class AppServices {

    internal let ddgEndpoint = "https://api.duckduckgo.com/"

}

extension AppServices: ReactiveCompatible {}
extension Reactive where Base: AppServices {

    var isAuthenticated: Observable<Bool> {
        return UserDefaults.standard
            .rx
            .observe(Bool.self, StoreKey.authToken.rawValue)
            .map { $0 ?? false }
    }
}
