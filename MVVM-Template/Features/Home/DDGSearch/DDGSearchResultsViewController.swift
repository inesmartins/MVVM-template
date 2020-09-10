import UIKit
import RxSwift
import RxRelay
import RxFlow

final class DDGSearchResultsViewController: KeyboardAwareViewController, ViewModelBased {

    // MARK: - UI components

    private lazy var resultContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var abstractTextField = self.makeUITextField()
    private lazy var abstractTextTextField = self.makeUITextField()
    private lazy var abstractSourceTextField = self.makeUITextField()
    private lazy var abstractURLTextField = self.makeUITextField()
    private lazy var abstractImageTextField = self.makeUITextField()
    private lazy var abstractHeadingTextField = self.makeUITextField()

    // MARK: - UIViewController Properties

    private let disposeBag = DisposeBag()
    var viewModel: DDGSearchResultsViewModel!
    let steps = PublishRelay<Step>()

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

private extension DDGSearchResultsViewController {

    func setupBindings() {
        self.viewModel.searchResult
            .map({ $0?.abstract.abstract ?? "" })
            .bind(to: self.abstractTextField.rx.text)
            .disposed(by: self.disposeBag)
        self.viewModel.searchResult
            .map({ $0?.abstract.abstractText ?? "" })
            .bind(to: self.abstractTextTextField.rx.text)
            .disposed(by: self.disposeBag)
        self.viewModel.searchResult
            .map({ $0?.abstract.abstractSource ?? "" })
            .bind(to: self.abstractSourceTextField.rx.text)
            .disposed(by: self.disposeBag)
        self.viewModel.searchResult
            .map({ $0?.abstract.abstractURL ?? "" })
            .bind(to: self.abstractURLTextField.rx.text)
            .disposed(by: self.disposeBag)
        self.viewModel.searchResult
            .map({ $0?.abstract.heading ?? "" })
            .bind(to: self.abstractHeadingTextField.rx.text)
            .disposed(by: self.disposeBag)

    }
}

private extension DDGSearchResultsViewController {

    func setupViews() {
        self.view.backgroundColor = .white
        self.addSubviews()
        self.addConstraints()
    }

    func addSubviews() {
        self.view.addSubview(self.resultContainer)
        self.resultContainer.addSubview(self.abstractTextField)
        self.resultContainer.addSubview(self.abstractTextTextField)
        self.resultContainer.addSubview(self.abstractSourceTextField)
        self.resultContainer.addSubview(self.abstractURLTextField)
        self.resultContainer.addSubview(self.abstractHeadingTextField)
        self.resultContainer.addSubview(self.abstractImageTextField)
    }

    func addConstraints() {
        let constraints = [
            self.resultContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.resultContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.resultContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.resultContainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)

        ]
        NSLayoutConstraint.activate(constraints)
    }

    func makeUITextField() -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }

}
