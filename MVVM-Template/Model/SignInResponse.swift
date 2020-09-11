import Foundation

class SignInResponse: Codable {

    let token: String
    let userId: String

    init(token: String, userId: String) {
        self.token = token
        self.userId = userId
    }
}
