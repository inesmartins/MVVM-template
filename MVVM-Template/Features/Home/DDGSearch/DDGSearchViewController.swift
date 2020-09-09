import UIKit
import RxSwift
import RxRelay
import RxFlow

final class DDGSearchViewController: KeyboardAwareViewController, ViewModelBased {

    // MARK: - UI components

    private lazy var searchInputField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    private lazy var searchButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    // MARK: - UIViewController Properties

    private let disposeBag = DisposeBag()
    var viewModel: DDGSearchViewModel!

    // MARK: - UIViewController Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.setupBindings()
    }

}

private extension DDGSearchViewController {

    func setupBindings() {
        self.searchInputField.rx.text
            .orEmpty
            .bind(to: self.viewModel.searchTerm)
            .disposed(by: self.disposeBag)
        self.searchButton.rx
            .tap
            .takeUntil(self.rx.deallocating)
            .bind {
                self.viewModel.search()
            }
            .disposed(by: self.disposeBag)
    }
}

private extension DDGSearchViewController {

    func setupViews() {
        self.view.backgroundColor = .white
        self.addSubviews()
        self.addConstraints()
    }

    func addSubviews() {
        self.view.addSubview(self.searchInputField)
        self.view.addSubview(self.searchButton)
    }

    func addConstraints() {
        let constraints = [
            self.searchInputField.heightAnchor.constraint(equalToConstant: 50.0),
            self.searchInputField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            self.searchInputField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0),
            self.searchInputField.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            self.searchButton.heightAnchor.constraint(equalToConstant: 50.0),
            self.searchButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            self.searchButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0),
            self.searchButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20.0)
        ]
        NSLayoutConstraint.activate(constraints)
    }

}
