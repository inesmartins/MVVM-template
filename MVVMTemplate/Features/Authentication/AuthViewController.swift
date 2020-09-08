import Foundation
import UIKit
import RxSwift
import RxCocoa

final class AuthViewController: KeyboardAwareViewController {

    private lazy var titleLabelContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sign in"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 22.0)
        return label
    }()
    private lazy var formContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.textContentType = .username
        textField.autocapitalizationType = .none
        return textField
    }()
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    private lazy var loginButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        return button
    }()
    
    // MARK: - Properties

    let disposeBag = DisposeBag()
    let viewModel: AuthViewModel

    // MARK: - Lifecycle Methods

    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.bindUsernameTextField()
        self.bindPasswordTextField()
        self.bindLoginButton()
    }

}

private extension AuthViewController {
    
    func bindUsernameTextField() {
        self.usernameTextField.rx.text
            .bind(to: self.viewModel.username)
            .disposed(by: self.disposeBag)
    }
    
    func bindPasswordTextField() {
        self.passwordTextField.rx.text
            .bind(to: self.viewModel.password)
            .disposed(by: self.disposeBag)
    }
    
    func bindLoginButton() {
        let usernameValidation = self.usernameTextField.rx.text
            .map({ !($0?.isEmpty ?? false) })
            .share(replay: 1)
        let passwordValidation = self.passwordTextField.rx.text
            .map({ !($0?.isEmpty ?? false) })
            .share(replay: 1)
        let enableButton = Observable.combineLatest(usernameValidation, passwordValidation) { (login, name) in
           return login && name
        }
        enableButton
            .bind(to: self.loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        self.loginButton.rx.controlEvent(.touchUpInside)
            .subscribe({ _ in
                // TODO: communicate with Coordinator
            })
    }
}

private extension AuthViewController {

    func setupView() {
        self.view.backgroundColor = .white
        self.addSubviews()
        self.addConstraints()
    }

    func addSubviews() {
        self.view.addSubview(self.titleLabelContainer)
        self.titleLabelContainer.addSubview(self.titleLabel)
        self.view.addSubview(self.formContainer)
        self.formContainer.addSubview(self.usernameTextField)
        self.formContainer.addSubview(self.passwordTextField)
        self.formContainer.addSubview(self.loginButton)
    }

    func addConstraints() {

        let constraints = [
            self.titleLabelContainer.heightAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.3),
            self.titleLabelContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.titleLabelContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor),

            self.formContainer.topAnchor.constraint(equalTo: self.titleLabelContainer.bottomAnchor),
            self.formContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.formContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.formContainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),

            self.titleLabel.centerXAnchor.constraint(equalTo: self.titleLabelContainer.centerXAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.titleLabelContainer.centerYAnchor),

            self.usernameTextField.heightAnchor.constraint(equalToConstant: 50.0),
            self.usernameTextField.widthAnchor.constraint(equalTo: self.formContainer.widthAnchor, multiplier: 0.8),
            self.usernameTextField.topAnchor.constraint(equalTo: self.formContainer.topAnchor),
            self.usernameTextField.centerXAnchor.constraint(equalTo: self.formContainer.centerXAnchor),

            self.passwordTextField.heightAnchor.constraint(equalToConstant: 50.0),
            self.passwordTextField.widthAnchor.constraint(equalTo: self.formContainer.widthAnchor, multiplier: 0.8),
            self.passwordTextField.topAnchor.constraint(equalTo: self.usernameTextField.bottomAnchor, constant: 20.0),
            self.passwordTextField.centerXAnchor.constraint(equalTo: self.formContainer.centerXAnchor),

            self.loginButton.heightAnchor.constraint(equalToConstant: 50.0),
            self.loginButton.widthAnchor.constraint(equalToConstant: 150.0),
            self.loginButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.loginButton.bottomAnchor.constraint(equalTo: self.formContainer.bottomAnchor, constant: -20.0)
        ]
        NSLayoutConstraint.activate(constraints)
    }

}
