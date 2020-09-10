import RxFlow
import RxSwift
import RxCocoa

class DDGSearchResultsViewModel: ServicesViewModel, Stepper {

    typealias Services = DDGServiceType
    var steps = PublishRelay<Step>()
    var services: DDGServiceType! {
        didSet {
            self.services.search(withParams: SearchParams(searchTerm: self.searchTerm), onCompletion: { res in
                do {
                    if let result = try res.get() {
                        self.searchResult = BehaviorRelay<SearchResult>(value: result)
                    }
                } catch let error {
                    print(error)
                }
            })
        }
    }

    let searchTerm: String
    private(set) var searchResult: BehaviorRelay<SearchResult>?

    init(searchTerm: String) {
        self.searchTerm = searchTerm
    }

}
