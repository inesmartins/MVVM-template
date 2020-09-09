import RxCocoa
import RxFlow

protocol CountryDetailViewModelType {
    func pickStore(_ store: Store)
}

class CountryDetailViewModel: ServicesViewModel, Stepper {

    let steps = PublishRelay<Step>()
    typealias Services = CountryServices

    var services: Services! {
        didSet {
            let country = self.services.countriesService.country(withName: self.name)
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
        guard let countryCode = self.code else {
            // TODO: implement error message
            return
        }
        let country = Country(name: self.name, code: countryCode)
        self.services.store.save(object: country, withKey: "SelectedStore", inStore: store, onCompletion: { result in
            print(result)
        })
    }

}
