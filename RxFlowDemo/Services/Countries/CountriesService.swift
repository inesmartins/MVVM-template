protocol HasCountriesService {
    var countriesService: CountriesService { get }
    var store: StoreServiceType { get }
}

class CountriesService {

    func all() -> [Country] {
        return CountriesRepository.countries
    }

    func country(withName name: String) -> Country? {
        return CountriesRepository.countries.filter { $0.name == name }.first
    }

}
