import RxFlow

enum AppStep: Step {

    // Global
    case authenticationRequired
    case userIsAuthenticated(withId: String?)
    case logoutIsRequired
    case alert(String)
    case fakeStep
    case unauthorized

    // Features
    case homeIsRequired
    case countryListIsRequired
    case countryWasPicked(withName: String)
    case searchIsRequired
    case showSearchResults(forSearchTerm: String)

}
