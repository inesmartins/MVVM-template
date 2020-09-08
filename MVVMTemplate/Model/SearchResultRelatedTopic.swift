import Foundation

final class SearchResultRelatedTopic: Codable {

    enum CodingKeys: String, CodingKey {
        case result = "Result"
        case firstURL = "FirstURL"
        case text = "Text"
        case icon = "Icon"
    }

    /** HTML link(s) to related topic(s) */
    private let result: String
    /** first URL in Result */
    private let firstURL: String
    /**  text from first URL */
    private let text: String
    /** icon associated with related topic(s) */
    private let icon: SearchResultRelatedTopicIcon

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {

            if let result = try values.decodeIfPresent(
                String.self, forKey: CodingKeys.result),
                let firstURL = try values.decodeIfPresent(
                    String.self, forKey: CodingKeys.firstURL),
                let text = try values.decodeIfPresent(
                    String.self, forKey: CodingKeys.text),
                let icon = try values.decodeIfPresent(
                    SearchResultRelatedTopicIcon.self, forKey: CodingKeys.icon) {

                self.result = result
                self.firstURL = firstURL
                self.text = text
                self.icon = icon

            } else {
                throw NSError(domain: "", code: 0, userInfo: nil)
            }
        } catch let error as NSError {
            throw error
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.result, forKey: CodingKeys.result.rawValue)
        aCoder.encode(self.firstURL, forKey: CodingKeys.firstURL.rawValue)
        aCoder.encode(self.text, forKey: CodingKeys.text.rawValue)
        aCoder.encode(self.icon, forKey: CodingKeys.icon.rawValue)
    }

}
