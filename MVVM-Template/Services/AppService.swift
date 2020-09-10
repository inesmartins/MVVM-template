import RxSwift

protocol AuthServiceType {
    func signIn(_ username: String, _ password: String) -> Single<SignInResponse>
}

protocol CountryServiceType {
    func all() -> [Country]
    func country(withName name: String) -> Country?
}

protocol DDGServiceType: AnyObject {
    func search(withParams: SearchParams, onCompletion: @escaping (Result<SearchResult?, Error>) -> Void)
}

final class AppService {

    internal let ddgEndpoint = "https://api.duckduckgo.com/"
    private let store: StoreServiceType

    init(store: StoreServiceType) {
        self.store = store
    }
}

extension AppService: ReactiveCompatible {}

extension Reactive where Base: AppService {
    var isOnboarded: Observable<Bool> {
        return UserDefaults.standard
            .rx
            .observe(Bool.self, UserPreferences.onBoarded)
            .map { $0 ?? false }
    }
}
