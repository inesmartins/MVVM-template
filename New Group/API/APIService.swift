import Foundation

typealias APIServiceType = AuthServiceType

protocol AuthServiceType: AnyObject {
    func validateLogin(
        _ username: String,
        _ password: String,
        onCompletion: @escaping ((_ authenticated: Bool) -> Void))
}

protocol DDGServiceType: AnyObject {
    func search(searchParams: SearchParams, onCompletion: @escaping (Result<SearchResult?, Error>) -> Void)
}

final class APIService {
    internal let ddgEndpoint = "https://api.duckduckgo.com/"
}
