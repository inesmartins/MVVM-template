import Foundation
import RxSwift
import RxFlow
import RxRelay

class HomeViewModel: Stepper {

    var steps = PublishRelay<Step>()
    
    private let disposeBag = DisposeBag()

    init() {
    }
}
