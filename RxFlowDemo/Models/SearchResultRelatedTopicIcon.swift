import Foundation

final class SearchResultRelatedTopicIcon: Codable {

    enum CodingKeys: String, CodingKey {
        case url = "URL"
        case height = "Height"
        case width = "Width"
    }

    /** URL of icon */
    private var url = "URL"
    /** height of icon (px) */
    private var height = "Height"
    /** width of icon (px) */
    private var width = "Width"

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            if let url = try values.decodeIfPresent(
                String.self, forKey: CodingKeys.url),
                let height = try values.decodeIfPresent(
                    String.self, forKey: CodingKeys.height),
                let width = try values.decodeIfPresent(
                    String.self, forKey: CodingKeys.width) {

                self.url = url
                self.height = height
                self.width = width

            } else {
                throw NSError(domain: "", code: 0, userInfo: nil)
            }
        } catch let error as NSError {
            throw error
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.url, forKey: CodingKeys.url.rawValue)
        aCoder.encode(self.height, forKey: CodingKeys.height.rawValue)
        aCoder.encode(self.width, forKey: CodingKeys.width.rawValue)
    }

}
