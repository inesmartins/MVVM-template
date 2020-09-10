import RxSwift

protocol AuthServiceType {
    var isAuthenticated: Observable<Bool> { get }
    func signIn(_ username: String, _ password: String) -> Single<SignInResponse>
}

protocol CountryServiceType {
    func allCountries() -> [Country]
    func country(withName name: String) -> Country?
}

protocol DDGServiceType: AnyObject {
    func search(withParams: SearchParams, onCompletion: @escaping (Result<SearchResult?, Error>) -> Void)
}

open class AppService {

    internal let ddgEndpoint = "https://api.duckduckgo.com/"
    internal let store: StoreServiceType

    init(store: StoreServiceType) {
        self.store = store
    }
}

extension AppService: ReactiveCompatible {

    var isAuthenticated: Observable<Bool> {
        return self.store.userDefaults.authToken.map({ $0 != nil ? true : false })
    }
}
