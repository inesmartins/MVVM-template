import RxSwift
import RxAlamofire
import Alamofire

extension AppServices: DDGServiceType {

    func search(withParams: SearchParams) -> Single<SearchResult> {
        return Single<SearchResult>.create { single in

            /// builds query string from search params and transforms to URL
            let urlString = "\(self.ddgEndpoint)?\(withParams.buildQuery())"
            guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
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
                    guard let data = $0.element?.data,
                        let result = data.to(type: SearchResult.self) else {
                        single(.error(NSError(domain: "Unable to get SearchResult", code: 0, userInfo: nil)))
                        return
                    }
                    single(.success(result))
                }
        }
    }

}
