import Foundation
import RxSwift

protocol HasPreferencesService {
    var preferencesService: PreferencesService { get }
}

/// Represents the keys that are used to store user defaults
struct UserPreferences {
    private init () {}

    /// key for onBoarded preference
    static let onBoarded = "onBoarded"
}

/// This service manage the user preferences
class PreferencesService {

    /// sets the onBoarded preference to true
    func setOnboarded () {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: UserPreferences.onBoarded)
    }

    /// removes the onBoarded preference
    func setNotOnboarded () {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: UserPreferences.onBoarded)
    }

    /// Returns true if the user has already onboarded, false otherwise
    ///
    /// - Returns: true if the user has already onboarded, false otherwise
    func isOnboarded () -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: UserPreferences.onBoarded)
    }
}
