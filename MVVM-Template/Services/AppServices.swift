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

class AppServices {

    internal let authEndpoint = "https://api.duckduckgo.com/"
    internal let ddgEndpoint = "https://api.duckduckgo.com/"

    private let session: Session

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

extension AppServices {

    internal func performGetRequest<T: Codable>(endpoint: String) -> Single<T> {
        return Single<T>.create { single in

            // TODO: improve this
            guard let encoded = endpoint.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                let url = URL(string: encoded) else {
                    let error = NSError(domain: "Unable to build query URL", code: 0, userInfo: nil)
                    return single(.error(error)) as! Disposable
            }

            return self.session.rx.request(.get, url)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: ["text/json"])
                .responseJSON()
                .observeOn(MainScheduler.instance)
                .subscribe {
                    if let error = $0.error {
                        single(.error(error))
                    }
                    guard let data = $0.element?.data else {
                        let error = NSError(domain: "Unable to get data with type \(T.self)", code: 0, userInfo: nil)
                        single(.error(error))
                        return
                    }
                    do {
                        let decoded = try JSONDecoder().decode(T.self, from: data)
                        single(.success(decoded))
                    } catch let error {
                        single(.error(error))
                        return
                    }
                }
        }
    }

}
