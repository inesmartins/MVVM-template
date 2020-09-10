import RxFlow
import RxSwift
import RxCocoa

class DDGSearchResultsViewModel: ServicesViewModel, Stepper {

    private let disposeBag = DisposeBag()
    typealias Services = DDGServiceType
    var steps = PublishRelay<Step>()
    var services: DDGServiceType! {
        didSet {
            self.services.search(withParams: SearchParams(searchTerm: self.searchTerm))
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { [weak self] result in
                    self?.searchResult.accept(result)
                }, onError: { [weak self] _ in
                    self?.searchResult.accept(nil)
                })
                .disposed(by: self.disposeBag)
        }
    }

    let searchTerm: String
    private(set) var searchResult = BehaviorRelay<SearchResult?>(value: nil)

    init(searchTerm: String) {
        self.searchTerm = searchTerm
    }

}
