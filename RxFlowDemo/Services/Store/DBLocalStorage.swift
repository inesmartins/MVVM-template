import Foundation

protocol DBLocalStorage {
    func storeObject<T>(_ object: T) throws
    func loadFirstObject<T: Codable>() throws -> T?
    func loadAllObjects<T: Codable>() throws -> [T]?
}
