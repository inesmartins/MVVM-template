import Foundation

final class SearchResultAbstract: Codable {

    enum CodingKeys: String, CodingKey {
        case abstract = "Abstract"
        case abstractText = "AbstractText"
        case abstractSource = "AbstractSource"
        case abstractURL = "AbstractURL"
        case image = "Image"
        case heading = "Heading"
    }

    /** topic summary (can contain HTML, e.g. italics) */
    var abstract: String
    /** topic summary (with no HTML) */
    var abstractText: String
    /** name of Abstract source */
    var abstractSource: String
    /** deep link to expanded topic page in AbstractSource */
    var abstractURL: String
    /** link to image that goes with Abstract */
    var image: String
    /** name of topic that goes with Abstract */
    var heading: String

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {

            if let abstract = try values.decodeIfPresent(
                String.self, forKey: SearchResultAbstract.CodingKeys.abstract),
                let abstractText = try values.decodeIfPresent(
                    String.self, forKey: SearchResultAbstract.CodingKeys.abstractText),
                let abstractSource = try values.decodeIfPresent(
                    String.self, forKey: SearchResultAbstract.CodingKeys.abstractSource),
                let abstractURL = try values.decodeIfPresent(
                    String.self, forKey: SearchResultAbstract.CodingKeys.abstractURL),
                let image = try values.decodeIfPresent(
                    String.self, forKey: SearchResultAbstract.CodingKeys.image),
                let heading = try values.decodeIfPresent(
                    String.self, forKey: SearchResultAbstract.CodingKeys.heading) {

                self.abstract = abstract
                self.abstractText = abstractText
                self.abstractSource = abstractSource
                self.abstractURL = abstractURL
                self.image = image
                self.heading = heading

            } else {
                throw NSError(domain: "", code: 0, userInfo: nil)
            }
        } catch let error as NSError {
            throw error
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.abstract, forKey: CodingKeys.abstract.rawValue)
        aCoder.encode(self.abstractText, forKey: CodingKeys.abstractText.rawValue)
        aCoder.encode(self.abstractSource, forKey: CodingKeys.abstractSource.rawValue)
        aCoder.encode(self.abstractURL, forKey: CodingKeys.abstractURL.rawValue)
        aCoder.encode(self.image, forKey: CodingKeys.image.rawValue)
        aCoder.encode(self.heading, forKey: CodingKeys.heading.rawValue)
    }
}
