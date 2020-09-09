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
    private lazy var abstractTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.viewModel.searchResult?
            .map({ $0.abstract.abstract })
            .bind(to: textField.rx.text)
            .disposed(by: self.disposeBag)
        return textField
    }()
    private lazy var abstractTextTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.viewModel.searchResult?
            .map({ $0.abstract.abstractText })
            .bind(to: textField.rx.text)
            .disposed(by: self.disposeBag)
        return textField
    }()
    private lazy var abstractSourceTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.viewModel.searchResult?
            .map({ $0.abstract.abstractSource })
            .bind(to: textField.rx.text)
            .disposed(by: self.disposeBag)
        return textField
    }()
    private lazy var abstractURLTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.viewModel.searchResult?
            .map({ $0.abstract.abstractURL })
            .bind(to: textField.rx.text)
            .disposed(by: self.disposeBag)
        return textField
    }()
    private lazy var abstractImageTextField: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var abstractHeadingTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.viewModel.searchResult?
            .map({ $0.abstract.heading })
            .bind(to: textField.rx.text)
            .disposed(by: self.disposeBag)
        return textField
    }()

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

}
