import RxSwift
import RxAlamofire
import Alamofire

extension AppServices: DDGServiceType {

    func search(withParams: SearchParams) -> Single<SearchResult> {
        let urlString = "\(self.ddgEndpoint)?\(withParams.buildQuery())"
        return self.performGetRequest(endpoint: urlString)
    }

}
