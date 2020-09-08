import Foundation
import RxSwift
import RxAlamofire

extension APIService: DDGServiceType {

    func search(searchParams: SearchParams, onCompletion: @escaping (Result<SearchResult?, Error>) -> Void) {

        let urlString = "\(self.ddgEndpoint)?\(searchParams.buildQuery())"
        guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
            onCompletion(.failure(NSError(domain: "Unable to create path", code: 0, userInfo: nil)))
            return
        }
        _ = request(.get, encoded)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (response) in
                do {
                    if let data = response.data {
                        let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                        onCompletion(.success(searchResult))
                    } else {
                        onCompletion(.success(nil))
                    }
                } catch let error {
                    onCompletion(.failure(error))
                }
            }, onError: { (error) in
                onCompletion(.failure(error))
            })
    }

}
