import Alamofire

extension APIService: AuthServiceType {

    func validateLogin(
        _ username: String,
        _ password: String,
        onCompletion: @escaping ((_ authenticated: Bool) -> Void)) {
        // TODO: implement authentication system
        onCompletion(true)
    }

}
