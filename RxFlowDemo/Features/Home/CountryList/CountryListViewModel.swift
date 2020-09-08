import RxFlow
import RxSwift
import RxCocoa

class CountryListViewModel: ServicesViewModel, Stepper {

    typealias Services = HasCountriesService

    private(set) var countries = [CountryViewModel]()
    let steps = PublishRelay<Step>()

    var services: Services! {
        didSet {
            self.countries = self.services.countriesService.all().map({ (country) -> CountryViewModel in
                return CountryViewModel(name: country.name, code: country.code)
            })
        }
    }

    public func pick(countryName: String) {
        self.steps.accept(AppStep.countryIsPicked(withName: countryName))
    }
}
