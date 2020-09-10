import RxCocoa
import RxFlow

enum Store: String, CaseIterable {

    case cache = "Cache (NSCache)"
    case userDefaults = "NSUserDefaults"
    case keychain = "KeyChain"
    case coreData = "Core Data"
    case textFile = "Text file"
    case sqlLite = "SQLite Database"
    case realm = "Realm"
}

protocol CountryDetailViewModelType {
    func pickStore(_ store: Store)
}

class CountryDetailViewModel: ServicesViewModel, Stepper {

    let steps = PublishRelay<Step>()
    typealias Services = CountryServiceType

    var services: Services! {
        didSet {
            let country = self.services.country(withName: self.name)
            self.code = country?.code
        }
    }

    let stores = Store.allCases
    let name: String
    private(set) var code: String?

    init(name: String, code: String? = nil) {
        self.name = name
        self.code = code
    }
}

extension CountryDetailViewModel: CountryDetailViewModelType {

    func pickStore(_ store: Store) {
        // TODO: fix store invocation
        /*
        guard let countryCode = self.code else {
            // TODO: implement error message
            return
        }
        let country = Country(name: self.name, code: countryCode)
        self.services.store.save(object: country, withKey: "SelectedStore", inStore: store, onCompletion: { result in
            print(result)
        })
        */
    }

}
