import Foundation

/** Wrapper around NSCache that allows any Hashable type as key, even those that are not subclasses of NSObject. */
final class Cache<Key: Hashable, Value> {

    private let cache = NSCache<WrappedKey, Entry>()
    private let dateProvider: () -> Date
    private let entryLifetime: TimeInterval
    private let keyTracker = KeyTracker()

    init(dateProvider: @escaping () -> Date = Date.init,
         entryLifetime: TimeInterval = 12 * 60 * 60,
         maximumEntryCount: Int = 50) {
        self.dateProvider = dateProvider
        self.entryLifetime = entryLifetime
        self.cache.countLimit = maximumEntryCount
        self.cache.delegate = keyTracker
    }

}

/** Forces Cache.Entry to adopt Codable when it has Codable Key and Value. */
extension Cache.Entry: Codable where Key: Codable, Value: Codable {}

/** Forces Cache to adopt Codable when it has Codable Key and Value. */
extension Cache: Codable where Key: Codable, Value: Codable {

    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.singleValueContainer()
        let entries = try container.decode([Entry].self)
        entries.forEach(self.insert)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.keyTracker.keys.compactMap(entry))
    }
}

extension Cache where Key: Codable, Value: Codable {

    /** Saves data-encoded "Codable" Cache objects to disk on the app’s caching directory. */
    func saveToDisk(
        withName name: String,
        using fileManager: FileManager = .default
    ) throws {
        let folderURLs = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        let fileURL = folderURLs[0].appendingPathComponent(name + ".cache")
        let data = try JSONEncoder().encode(self)
        try data.write(to: fileURL)
    }
}

extension Cache {

    /** Wrapper around Key objects in order to make them NSCache compatible. */
    final class WrappedKey: NSObject {

        let key: Key
        init(_ key: Key) {
            self.key = key
        }

        // Overrides methods used by Objective-C to determine whether two instances are equal
        override var hash: Int { return key.hashValue }
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }
            return value.key == key
        }
    }

    final class Entry {

        let key: Key
        let value: Value
        let expirationDate: Date

        init(key: Key, value: Value, expirationDate: Date) {
            self.key = key
            self.value = value
            self.expirationDate = expirationDate
        }
    }

    func insert(_ value: Value, forKey key: Key) {
        let date = self.dateProvider().addingTimeInterval(self.entryLifetime)
        let entry = Entry(key: key, value: value, expirationDate: date)
        self.cache.setObject(entry, forKey: WrappedKey(key))
        self.keyTracker.keys.insert(key)
    }

    func value(forKey key: Key) -> Value? {
        guard let entry = self.cache.object(forKey: WrappedKey(key)) else {
            return nil
        }
        guard dateProvider() < entry.expirationDate else {
            self.removeValue(forKey: key)
            return nil
        }
        return entry.value
    }

    func removeValue(forKey key: Key) {
        self.cache.removeObject(forKey: WrappedKey(key))
    }

    subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                // If nil was assigned using our subscript,
                // then we remove any value for that key:
                self.removeValue(forKey: key)
                return
            }
            self.insert(value, forKey: key)
        }
    }
}

private extension Cache {

    /**
     Delegate of the underlying NSCache.
     Is notified whenever an entry is removed and updates "keys" sets correspondingly */
    final class KeyTracker: NSObject, NSCacheDelegate {
        var keys = Set<Key>()
        func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject object: Any) {
            guard let entry = object as? Entry else {
                return
            }
            self.keys.remove(entry.key)
        }
    }
}

private extension Cache {

    /** Retrieves Entry from NSCache after checking expiration date. */
    func entry(forKey key: Key) -> Entry? {
        guard let entry = self.cache.object(forKey: WrappedKey(key)) else {
            return nil
        }
        guard self.dateProvider() < entry.expirationDate else {
            self.removeValue(forKey: key)
            return nil
        }
        return entry
    }

    /** Adds Entry to NSCache and updates KeyTracker with new key. */
    func insert(_ entry: Entry) {
        self.cache.setObject(entry, forKey: WrappedKey(entry.key))
        self.keyTracker.keys.insert(entry.key)
    }
}
