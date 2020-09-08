import RxFlow

enum AppStep: Step {

    // Global
    case authenticationRequired
    case userIsAuthenticated
    case logoutIsRequired
    case alert(String)
    case fakeStep
    case unauthorized

    // Home
    case homeIsRequired

    // Country List
    case countryListIsRequired

    // Movies
    case moviesAreRequired
    case movieIsPicked (withId: Int)
    case castIsPicked (withId: Int)

    // Settings
    case settingsAreRequired
    case settingsAreComplete

    // About
    case aboutIsRequired
    case aboutIsComplete
}
