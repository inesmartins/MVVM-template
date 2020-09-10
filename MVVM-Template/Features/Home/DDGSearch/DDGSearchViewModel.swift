import RxFlow
import RxSwift
import RxCocoa

protocol DDGSearchViewModelType {
    func search()
}

class DDGSearchViewModel: ServicesViewModel, Stepper {
    typealias Services = DDGServiceType
    var services: DDGServiceType!
    var steps = PublishRelay<Step>()
    let searchTerm = BehaviorSubject<String>(value: "")
}

extension DDGSearchViewModel: DDGSearchViewModelType {

    func search() {
        do {
            let term = try self.searchTerm.value()
            self.steps.accept(AppStep.showSearchResults(forSearchTerm: term))
        } catch let error {
            print(error)
        }
    }
}
