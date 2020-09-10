import RxSwift
import RxAlamofire
import Alamofire

extension AppService: DDGServiceType {

    func search(withParams: SearchParams, onCompletion: @escaping (Result<SearchResult?, Error>) -> Void) {

        let urlString = "\(self.ddgEndpoint)?\(withParams.buildQuery())"
        guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let url = URL(string: encoded) else {
                onCompletion(.failure(NSError(domain: "Unable to create path", code: 0, userInfo: nil)))
                return
        }
        AF.request(url).response { result in
            if let error = result.error {
                onCompletion(.failure(error))
            } else if let resultData = result.data {
                do {
                    let searchResult = try JSONDecoder().decode(SearchResult.self, from: resultData)
                    onCompletion(.success(searchResult))
                } catch {
                    onCompletion(.success(nil))
                }
            } else {
                onCompletion(.success(nil))
            }
        }
    }

}
