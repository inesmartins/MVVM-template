import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxFlow

class AuthViewController: KeyboardAwareViewController, ViewModelBased, Stepper {

    lazy var formContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var usernamTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "username"
        textField.borderStyle = .roundedRect
        textField.textContentType = .username
        textField.autocapitalizationType = .none
        return textField
    }()
    lazy var passwordTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    lazy var errorMessageTextField: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var loginButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.backgroundColor = .gray
        return button
    }()

    // MARK: - UIViewController Properties

    private let disposeBag = DisposeBag()
    var viewModel: AuthViewModel!
    let steps = PublishRelay<Step>()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupBindings()
    }

}

private extension AuthViewController {

    func setupBindings() {
        self.usernamTextField.rx.text.orEmpty
            .takeUntil(self.rx.deallocating)
            .bind(to: self.viewModel.username)
            .disposed(by: self.disposeBag)
        self.passwordTextField.rx.text.orEmpty
            .takeUntil(self.rx.deallocating)
            .bind(to: self.viewModel.password)
            .disposed(by: self.disposeBag)
        self.viewModel.isValid
            .takeUntil(self.rx.deallocating)
            .bind(to: self.loginButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        self.loginButton.rx.tap
            .takeUntil(self.rx.deallocating)
            .bind(onNext: {
                self.viewModel.validateLogin()
            }).disposed(by: self.disposeBag)
        self.viewModel.didFailSignIn
            .subscribe(onNext: { error in
                // TODO: bind to label
                print("Failed: \(error)")
                // show error
            })
            .disposed(by: self.disposeBag)
    }

}

private extension AuthViewController {

    func setupView() {
        self.view.backgroundColor = .white
        self.addSubviews()
        self.addConstraints()
    }

    func addSubviews() {
        self.view.addSubview(self.formContainer)
        self.formContainer.addSubview(self.usernamTextField)
        self.formContainer.addSubview(self.passwordTextField)
        self.formContainer.addSubview(self.errorMessageTextField)
        self.view.addSubview(self.loginButton)
    }

    func addConstraints() {
        let constraints: [NSLayoutConstraint] = [
            self.formContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40.0),
            self.formContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40.0),
            self.formContainer.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),

            self.usernamTextField.heightAnchor.constraint(equalToConstant: 40.0),
            self.usernamTextField.topAnchor.constraint(equalTo: self.formContainer.topAnchor),
            self.usernamTextField.leadingAnchor.constraint(equalTo: self.formContainer.leadingAnchor),
            self.usernamTextField.trailingAnchor.constraint(equalTo: self.formContainer.trailingAnchor),

            self.passwordTextField.heightAnchor.constraint(equalToConstant: 40.0),
            self.passwordTextField.topAnchor.constraint(equalTo: self.usernamTextField.bottomAnchor, constant: 20.0),
            self.passwordTextField.leadingAnchor.constraint(equalTo: self.formContainer.leadingAnchor),
            self.passwordTextField.trailingAnchor.constraint(equalTo: self.formContainer.trailingAnchor),

            self.errorMessageTextField.heightAnchor.constraint(equalToConstant: 40.0),
            self.errorMessageTextField.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 20.0),
            self.errorMessageTextField.leadingAnchor.constraint(equalTo: self.formContainer.leadingAnchor),
            self.errorMessageTextField.trailingAnchor.constraint(equalTo: self.formContainer.trailingAnchor),
            self.errorMessageTextField.bottomAnchor.constraint(equalTo: self.formContainer.bottomAnchor),

            self.loginButton.heightAnchor.constraint(equalToConstant: 40.0),
            self.loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40.0),
            self.loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40.0),
            self.loginButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40.0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
