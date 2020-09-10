import CoreData

protocol StoreServiceType: AnyObject {
    var coreData: CoreDataStorage { get }
    var userDefaults: UserDefaultsStorage { get }
    var keychain: KeyChainStorage { get }
}

final class StoreService: StoreServiceType {

    let coreData: CoreDataStorage
    let userDefaults: UserDefaultsStorage
    let keychain: KeyChainStorage

    init(coreDataStorage: CoreDataStorage, userDefaultsStorage: UserDefaultsStorage, keychainStorage: KeyChainStorage) {
        self.coreData = coreDataStorage
        self.userDefaults = userDefaultsStorage
        self.keychain = keychainStorage
    }
}
