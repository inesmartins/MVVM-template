import Foundation

final class UserDefaultsStorage {
    let defaults = UserDefaults.standard
}

extension UserDefaultsStorage: KeyValueLocalStorage {

    func insert<T: Codable>(_ object: T, forKey key: String) throws {
        self.defaults.set(Data(from: object), forKey: key)
    }

    func value<T: Codable>(forKey key: String) throws -> T? {
        guard let data = self.defaults.data(forKey: key),
            let object = data.to(type: T.self) else {
            return nil
        }
        return object
    }

}
