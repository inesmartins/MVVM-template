import RxFlow
import RxSwift
import RxCocoa

protocol CountryListViewModelType {
    func pickCountry(withName: String)
}

class CountryListViewModel: ServicesViewModel, Stepper {

    let steps = PublishRelay<Step>()
    typealias Services = HasCountriesService

    private(set) var countries = [CountryDetailViewModel]()

    var services: Services! {
        didSet {
            self.countries = self.services.countriesService.all().map({ country -> CountryDetailViewModel in
                return CountryDetailViewModel(name: country.name, code: country.code)
            })
        }
    }

}

extension CountryListViewModel: CountryListViewModelType {

    func pickCountry(withName: String) {
        self.steps.accept(AppStep.countryIsPicked(withName: withName))
    }

}
