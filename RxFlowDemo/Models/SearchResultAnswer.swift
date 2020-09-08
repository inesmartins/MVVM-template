import Foundation

final class SearchResultAnswer: Codable {

    enum CodingKeys: String, CodingKey {
        case answer = "Answer"
        case answerType = "AnswerType"
    }

    /** instant answer */
    var answer: String
    /** calc, color, digest, info, ip, iploc, phone, pw, rand, regexp, unicode, upc, or zip. */
    var answerType: String

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            if let answer = try values.decodeIfPresent(
                String.self, forKey: SearchResultAnswer.CodingKeys.answer),
                let answerType = try values.decodeIfPresent(
                String.self, forKey: SearchResultAnswer.CodingKeys.answer) {
                self.answer = answer
                self.answerType = answerType
            } else {
                throw NSError(domain: "", code: 0, userInfo: nil)
            }
        } catch let error as NSError {
            throw error
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.answer, forKey: CodingKeys.answer.rawValue)
        aCoder.encode(self.answerType, forKey: CodingKeys.answerType.rawValue)
    }

}
