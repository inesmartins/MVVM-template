protocol CountryServices {
    var countriesService: CountryServiceType { get }
    var store: StoreServiceType { get }
}

protocol CountryServiceType {
    func all() -> [Country]
    func country(withName name: String) -> Country?
}

class CountryService: CountryServiceType {

    func all() -> [Country] {
        return CountriesRepository.countries
    }

    func country(withName name: String) -> Country? {
        return CountriesRepository.countries.filter { $0.name == name }.first
    }

}
