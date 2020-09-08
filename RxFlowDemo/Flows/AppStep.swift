import RxFlow

enum AppStep: Step {
    // Global
    case logoutIsRequired
    case dashboardIsRequired
    case alert(String)
    case fakeStep
    case unauthorized

    // Login
    case loginIsRequired
    case userIsLoggedIn

    // Onboarding
    case onboardingIsRequired
    case onboardingIsComplete

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
