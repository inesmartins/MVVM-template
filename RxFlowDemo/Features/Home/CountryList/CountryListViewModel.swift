import RxFlow
import RxSwift
import RxCocoa

protocol CountryListViewModelType {
    func pickCountry(withName: String)
}

class CountryListViewModel: ServicesViewModel, Stepper {

    let steps = PublishRelay<Step>()
    typealias Services = CountryServices

    private(set) var countries = [CountryDetailViewModel]()
    private(set) var savedCountry: CountryDetailViewModel?

    var services: Services! {
        didSet {
            self.countries = self.services.countriesService.all().map({ country -> CountryDetailViewModel in
                return CountryDetailViewModel(name: country.name, code: country.code)
            })
            self.services.store.load(fromStore: .keychain, withKey: "SelectedStore", onCompletion: { (res: Result<Country?, Error>) in
                do {
                    if let country: Country = try res.get() {
                        self.savedCountry = CountryDetailViewModel(name: country.name, code: country.code)
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            })
        }
    }

}

extension CountryListViewModel: CountryListViewModelType {

    func pickCountry(withName: String) {
        self.steps.accept(AppStep.countryWasPicked(withName: withName))
    }

}
