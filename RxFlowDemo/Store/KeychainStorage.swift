import Foundation
import Security

final class KeyChainStorage {

    private class SecKey {
        static let itemClass = kSecClass as String
        static let genericPasswordClass = kSecClassGenericPassword as String
        static let itemAccountName = kSecAttrAccount as String
        static let itemData = kSecValueData as String
        static let shouldReturnData = kSecReturnData as String
        static let trueBoolean = kCFBooleanTrue!
        static let matchLimit = kSecMatchLimit as String
        static let matchOne = kSecMatchLimitOne
    }

}

extension KeyChainStorage: KeyValueLocalStorage {

    func insert<T: Codable>(_ object: T, forKey key: String) throws {

        let data = Data(from: object)
        let query = [
            SecKey.itemClass: SecKey.genericPasswordClass,
            SecKey.itemAccountName: key,
            SecKey.itemData: data
        ] as CFDictionary

        // removes previous entry
        let deleteStatus = SecItemDelete(query)
        guard deleteStatus == noErr || deleteStatus == errSecItemNotFound else {
            throw NSError(
                domain: "Error while deleting previous entry: \(deleteStatus.description)",
                code: 0, userInfo: nil)
        }

        // adds new entry
        let addStatus = SecItemAdd(query, nil)
        guard addStatus == errSecSuccess else {
            throw NSError(
                domain: "Error while adding new entry: \(addStatus.description)",
                code: 0, userInfo: nil)
        }
    }

    func value<T: Codable>(forKey: String) throws -> T? {

        let query = [
            SecKey.itemClass: SecKey.genericPasswordClass,
            SecKey.itemAccountName: forKey,
            SecKey.shouldReturnData: SecKey.trueBoolean,
            SecKey.matchLimit: SecKey.matchOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let loadStatus: OSStatus = SecItemCopyMatching(query, &dataTypeRef)
        if loadStatus == errSecItemNotFound {
            return nil
        }
        guard loadStatus == errSecSuccess,
            let data = dataTypeRef as? Data,
            let object = data.to(type: T.self) else {
            throw NSError(domain: "Unable to load entry from keychain", code: 0, userInfo: nil)
        }
        return object
    }

}
