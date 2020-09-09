protocol AuthServices {
    var authServiceType: AuthServiceType { get }
}

protocol AuthServiceType {
    func validateLogin(
    _ username: String,
    _ password: String,
    onCompletion: @escaping ((_ authenticated: Bool) -> Void))
}

class AuthService: AuthServiceType {

    func validateLogin(
        _ username: String,
        _ password: String,
        onCompletion: @escaping ((_ authenticated: Bool) -> Void)) {
        // TODO: implement authentication system
        onCompletion(true)
    }

}
