import Alamofire
import RxAlamofire

class AppURLSession: URLSession {

    let urlSession: URLSession = {

        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 120
        configuration.timeoutIntervalForResource = 120

        /// added to make sure app reacts to lack of network connectivity
        if #available(iOS 11, *) {
          configuration.waitsForConnectivity = true
        }
        return URLSession(configuration: configuration)
    }()

    init() {
        super.init(session: self.urlSession, delegate: SessionDelegate(), rootQueue: queue)
    }

}
