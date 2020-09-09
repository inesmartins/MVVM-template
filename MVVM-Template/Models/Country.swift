import Foundation

final class Country: Codable {

    enum CodingKeys: String, CodingKey {
        case name
        case code
    }

    let name: String
    let code: String

    init(name: String, code: String) {
        self.name = name
        self.code = code
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            if let name = try values.decodeIfPresent(String.self, forKey: Country.CodingKeys.name),
                let code = try values.decodeIfPresent(String.self, forKey: Country.CodingKeys.code) {
                self.name = name
                self.code = code
            } else {
                throw NSError(domain: "", code: 0, userInfo: nil)
            }
        } catch let error as NSError {
            throw error
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: CodingKeys.name.rawValue)
        aCoder.encode(self.code, forKey: CodingKeys.code.rawValue)
    }

}
