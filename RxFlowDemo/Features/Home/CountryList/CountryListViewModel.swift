import RxFlow
import RxSwift
import RxCocoa

class CountryListViewModel: ServicesViewModel, Stepper {

    typealias Services = HasCountriesService

    private(set) var countries = [CountryDetailViewModel]()
    let steps = PublishRelay<Step>()

    var services: Services! {
        didSet {
            self.countries = self.services.countriesService.all().map({ country -> CountryDetailViewModel in
                return CountryDetailViewModel(name: country.name, code: country.code)
            })
        }
    }

    public func pickCountry(withName: String) {
        self.steps.accept(AppStep.countryIsPicked(withName: withName))
    }

}
