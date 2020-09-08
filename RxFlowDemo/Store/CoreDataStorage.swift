import Foundation
import CoreData

final class CoreDataStorage {

    // MARK: - CoreData Entities

    private lazy var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "VIPERBoilerplate")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()
    private let countryEntityName = "CountryEntity"
    private lazy var countryEntity = NSEntityDescription.entity(forEntityName: self.countryEntityName, in: self.context)

}

extension CoreDataStorage: DBLocalStorage {

    func storeObject<T>(_ object: T) throws {
        if let country = object as? Country {
            guard let countryEntity = self.countryEntity else {
                throw NSError(domain: "Could not find Country entity on CoreData", code: 0, userInfo: nil)
            }
            let newCountry = NSManagedObject(entity: countryEntity, insertInto: self.context)
            newCountry.setValue(country.name, forKey: Country.CodingKeys.name.rawValue)
            newCountry.setValue(country.code, forKey: Country.CodingKeys.code.rawValue)
        }
        try self.saveContext()
    }

    func loadFirstObject<T: Codable>() throws -> T? {
        if T.self == Country.self, let country = self.loadFirstCountry() as? T {
            return country
        }
        return nil
    }

    func loadAllObjects<T: Codable>() throws -> [T]? {
        if T.self == Country.self, let allCountries = self.loadAllCountries() as? [T] {
            return allCountries
        }
        return nil
    }

}

private extension CoreDataStorage {

    func loadAllCountries() -> [Country]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.countryEntityName)
        request.returnsObjectsAsFaults = false
        do {
            guard let result = try context.fetch(request) as? [NSManagedObject] else { return nil }
            var parsedCountries = [Country]()
            for data in result {
                if let countryName = data.value(forKey: Country.CodingKeys.name.rawValue) as? String,
                    let countryCode = data.value(forKey: Country.CodingKeys.code.rawValue) as? String {
                    let parsedCountry = Country(name: countryName, code: countryCode)
                    parsedCountries.append(parsedCountry)
                }
            }
            return parsedCountries
        } catch {
            return nil
        }
    }

    func loadFirstCountry() -> Country? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.countryEntityName)
        request.returnsObjectsAsFaults = false
        do {
            guard let result = try context.fetch(request) as? [NSManagedObject] else { return nil }
            if result.count > 0 {
                if let countryName = result[0].value(forKey: Country.CodingKeys.name.rawValue) as? String,
                    let countryCode = result[0].value(forKey: Country.CodingKeys.code.rawValue) as? String {
                    return Country(name: countryName, code: countryCode)
                }
            }
            return nil
        } catch {
            return nil
        }
    }

    func saveContext () throws {
        if self.context.hasChanges {
            do {
                try context.save()
            } catch {
                throw error
            }
        }
    }
}
