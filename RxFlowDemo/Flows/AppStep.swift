import RxFlow

enum AppStep: Step {

    // Global
    case authenticationRequired
    case userIsAuthenticated
    case logoutIsRequired
    case alert(String)
    case fakeStep
    case unauthorized

    // Features
    case homeIsRequired
    case countryListIsRequired
    case countryIsPicked(withName: String)

}
