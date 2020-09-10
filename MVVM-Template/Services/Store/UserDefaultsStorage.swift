import RxSwift

typealias JWT = String

protocol UserDefaultsStorageType {
    var authToken: BehaviorSubject<JWT?> { get }
}

final class UserDefaultsStorage: UserDefaultsStorageType {

    private let userDefaults: UserDefaults
    private let disposeBag = DisposeBag()

    var authToken = BehaviorSubject<JWT?>(value: nil)

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        self.userDefaults.rx
            .observe(String.self, StoreKey.authToken.rawValue)
            .subscribe(onNext: { (value) in
                self.authToken.onNext(value)
            }).disposed(by: disposeBag)
    }

}

extension UserDefaultsStorage: KeyValueLocalStorage {

    func insert<T: Codable>(_ object: T, forKey key: String) throws {
        self.userDefaults.set(Data(from: object), forKey: key)
    }

    func value<T: Codable>(forKey key: String) throws -> T? {
        guard let data = self.userDefaults.data(forKey: key),
            let object = data.to(type: T.self) else {
            return nil
        }
        return object
    }

    func removeValue(forKey key: String) throws {
        self.userDefaults.removeObject(forKey: key)
    }

}
