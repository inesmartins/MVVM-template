import Foundation

final class SearchResult: Codable {

    enum CodingKeys: CodingKey {
    }

    var abstract: SearchResultAbstract
    var answer: SearchResultAnswer
    var definition: SearchResultDefinition
    /**  array of internal links to related topics associated with Abstract */
    var relatedTopics: SearchResultRelatedTopic

    required init(from decoder: Decoder) throws {
        do {
            self.abstract = try SearchResultAbstract(from: decoder)
            self.answer = try SearchResultAnswer(from: decoder)
            self.definition = try SearchResultDefinition(from: decoder)
            self.relatedTopics  = try SearchResultRelatedTopic(from: decoder)
        } catch let error as NSError {
            throw error
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.abstract)
        aCoder.encode(self.answer)
        aCoder.encode(self.definition)
    }

}

/*
 Results: array of external links associated with Abstract
   Result: HTML link(s) to external site(s)
   FirstURL: first URL in Result
   Icon: icon associated with FirstURL
     URL: URL of icon
     Height: height of icon (px)
     Width: width of icon (px)
   Text: text from FirstURL
 Type: response category, i.e. A (article), D (disambiguation), C (category), N (name), E (exclusive), or nothing.
 Redirect: !bang redirect URL
 */
