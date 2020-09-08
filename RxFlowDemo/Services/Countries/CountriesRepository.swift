import Foundation

struct CountriesRepository {

    static let countries: [Country] = {
        if let filepath = Bundle.main.path(forResource: "CountryList", ofType: "json") {
            do {
                if let data = try String(contentsOfFile: filepath).data(using: .utf8) {
                    let decodedData = try JSONDecoder().decode([Country].self, from: data)
                    return decodedData
                }
            } catch {
                return [Country]()
            }
        }
        return [Country]()
    }()

}
