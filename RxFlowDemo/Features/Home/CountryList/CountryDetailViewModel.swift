import RxCocoa
import RxFlow

class CountryDetailViewModel: ServicesViewModel, Stepper {

    let stores = Store.allCases

    let steps = PublishRelay<Step>()
    typealias Services = HasCountriesService

    var services: Services! {
        didSet {
            let country = self.services.countriesService.country(withName: self.name)
            self.code = country?.code
        }
    }

    let name: String
    var code: String?

    init(name: String, code: String? = nil) {
        self.name = name
        self.code = code
    }

    public func pickStore(_ store: Store) {
        let country = Country(name: self.name, code: self.code!)
        self.services.store.save(object: country, withKey: "SelectedStore", inStore: store, onCompletion: { _ in

        })
    }

}
