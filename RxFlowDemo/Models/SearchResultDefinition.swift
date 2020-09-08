import Foundation

final class SearchResultDefinition: Codable {

    enum CodingKeys: String, CodingKey {
        case definition = "Definition"
        case definitionSource = "DefinitionSource"
        case definitionURL = "DefinitionURL"
    }

    /** dictionary definition (may differ from Abstract) */
    private var definition: String
    /** name of Definition source */
    private var definitionSource: String
    /** deep link to expanded definition page in DefinitionSource */
    private var definitionURL: String

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            if let definition = try values.decodeIfPresent(
                    String.self, forKey: SearchResultDefinition.CodingKeys.definition),
                let definitionSource = try values.decodeIfPresent(
                    String.self, forKey: SearchResultDefinition.CodingKeys.definitionSource),
                let definitionURL = try values.decodeIfPresent(
                    String.self, forKey: SearchResultDefinition.CodingKeys.definitionURL) {

                self.definition = definition
                self.definitionSource = definitionSource
                self.definitionURL = definitionURL

            } else {
                throw NSError(domain: "", code: 0, userInfo: nil)
            }
        } catch let error as NSError {
            throw error
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.definition, forKey: CodingKeys.definition.rawValue)
        aCoder.encode(self.definitionSource, forKey: CodingKeys.definitionSource.rawValue)
        aCoder.encode(self.definitionURL, forKey: CodingKeys.definitionURL.rawValue)
    }
}
