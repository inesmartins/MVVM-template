import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxFlow

class AuthViewController: UIViewController, StoryboardBased, ViewModelBased, Stepper {

    @IBOutlet weak var usernamTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var proceedButton: UIButton!

    // MARK: - UIViewController Properties

    private let disposeBag = DisposeBag()
    var viewModel: AuthViewModel!
    let steps = PublishRelay<Step>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBindings()
    }

}

private extension AuthViewController {

    func setupBindings() {
        self.usernamTextField.rx.text
            .orEmpty
            .bind(to: self.viewModel.username)
            .disposed(by: self.disposeBag)
        self.passwordTextField.rx.text
            .orEmpty
            .bind(to: self.viewModel.password)
            .disposed(by: self.disposeBag)
        self.proceedButton.rx.tap
            .takeUntil(self.rx.deallocating)
            .bind(onNext: {
                self.viewModel.validateLogin()
            })
            .disposed(by: self.disposeBag)
    }

}
