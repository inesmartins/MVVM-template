import RxFlow
import RxSwift
import RxCocoa

class CountryListViewModel: ServicesViewModel, Stepper {

    typealias Services = HasCountriesService

    private(set) var countries = [CountryViewModel]()
    let steps = PublishRelay<Step>()

    var services: Services! {
        didSet {
            // we can do some data refactoring in order to display things exactly the way we want (this is the aim of a ViewModel)
            self.countries = self.services.countriesService.all().map({ (country) -> CountryViewModel in
                return CountryViewModel(name: country.name, code: country.code)
            })
        }
    }

    //public func pick(movieId: Int) {
    //    self.steps.accept(AppStep.movieIsPicked(withId: movieId))
    //}
}
