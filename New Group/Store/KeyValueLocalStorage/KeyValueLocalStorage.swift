import Foundation

protocol KeyValueLocalStorage {
    func insert<T: Codable>(_ object: T, forKey key: String) throws
    func value<T: Codable>(forKey: String) throws -> T?
}
