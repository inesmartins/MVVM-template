import RxFlow

enum AppStep: Step {
    case loginIsRequired
    case logoutIsRequired
    case userIsLoggedIn
    case alert(String)
    case countryIsSelected(withName: String)
}
