import RxSwift
import RxAlamofire

extension AppServices: CountryServiceType {

    func allCountries() -> [Country] {
        return CountriesRepository.countries
    }

    func country(withName name: String) -> Country? {
        return CountriesRepository.countries.filter { $0.name == name }.first
    }

}
