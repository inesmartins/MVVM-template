import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxFlow

class AuthViewController: UIViewController, ViewModelBased, Stepper {

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
        return textField
    }()
    lazy var passwordTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "password"
        textField.borderStyle = .roundedRect
        return textField
    }()
    lazy var loginButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .gray
        return button
    }()

    // MARK: - UIViewController Properties

    private let disposeBag = DisposeBag()
    var viewModel: AuthViewModel!
    let steps = PublishRelay<Step>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
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
        self.loginButton.rx.tap
            .takeUntil(self.rx.deallocating)
            .bind(onNext: {
                self.viewModel.validateLogin()
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
        self.view.addSubview(self.loginButton)
    }

    func addConstraints() {
        let constraints: [NSLayoutConstraint] = [

            self.formContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50.0),
            self.formContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50.0),
            self.formContainer.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),

            self.usernamTextField.heightAnchor.constraint(equalToConstant: 40.0),
            self.usernamTextField.topAnchor.constraint(equalTo: self.formContainer.topAnchor),
            self.usernamTextField.leadingAnchor.constraint(equalTo: self.formContainer.leadingAnchor),
            self.usernamTextField.trailingAnchor.constraint(equalTo: self.formContainer.trailingAnchor),

            self.passwordTextField.heightAnchor.constraint(equalToConstant: 40.0),
            self.passwordTextField.topAnchor.constraint(equalTo: self.usernamTextField.bottomAnchor, constant: 20.0),
            self.passwordTextField.leadingAnchor.constraint(equalTo: self.formContainer.leadingAnchor),
            self.passwordTextField.trailingAnchor.constraint(equalTo: self.formContainer.trailingAnchor),
            self.passwordTextField.bottomAnchor.constraint(equalTo: self.formContainer.bottomAnchor),

            self.loginButton.heightAnchor.constraint(equalToConstant: 30.0),
            self.loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            self.loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0),
            self.loginButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20.0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
