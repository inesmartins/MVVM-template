import RxCocoa
import RxFlow

class CountryDetailViewModel: ServicesViewModel, Stepper {

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
        // TODO: implement
    }

}
