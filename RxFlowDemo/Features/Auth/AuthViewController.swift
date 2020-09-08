import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxFlow

class AuthViewController: UIViewController, StoryboardBased, Stepper {

    @IBOutlet weak var proceedButton: UIButton!

    let steps = PublishRelay<Step>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _ = proceedButton.rx.tap
            .takeUntil(self.rx.deallocating)
            .map { AppStep.userIsAuthenticated }
            .bind(to: self.steps)
    }

}
