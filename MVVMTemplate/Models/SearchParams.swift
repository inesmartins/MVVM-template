import Foundation

final class SearchParams: Codable {

    enum SearchFormat: String, Codable {
        case json
        case xml
    }

    private let queryParam = "q"
    private let formatParam = "format"
    private let noRedirectsParam = "no_redirect"
    private let noHTMLParam = "no_html"
    private let skipDisambiguationParam = "skip_disambig"

    let searchTerm: String
    let format: SearchFormat
    let enforceNoRedirects: Bool
    let removeFormatting: Bool
    let skipDisambiguation: Bool

    init(searchTerm: String,
         format: SearchFormat = .json,
         enforceNoRedirects: Bool = false,
         removeFormatting: Bool = false,
         skipDisambiguation: Bool = false) {

        self.searchTerm = searchTerm
        self.format = format
        self.enforceNoRedirects = enforceNoRedirects
        self.removeFormatting = removeFormatting
        self.skipDisambiguation = skipDisambiguation
    }

    func buildQuery() -> String {
        var query = "\(self.queryParam)=\(self.searchTerm)"
        query += "&\(self.formatParam)=\(self.format.rawValue)"
        query += "&\(self.noRedirectsParam)=\(self.enforceNoRedirects ? 1 : 0)"
        query += "&\(self.noRedirectsParam)=\(self.removeFormatting ? 1 : 0)"
        query += "&\(self.skipDisambiguationParam)=\(self.skipDisambiguation ? 1 : 0)"
        return query
    }
}
