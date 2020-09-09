import UIKit
import Reusable
import RxFlow
import RxSwift
import RxCocoa

class CountryDetailViewController: UIViewController, ViewModelBased {

    // MARK: - UI components

    private lazy var saveCountryButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("Save Country", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    // MARK: - UIViewController Properties

    private let disposeBag = DisposeBag()
    var viewModel: CountryDetailViewModel!
    let steps = PublishRelay<Step>()

    // MARK: - Lifecycle Methods

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupBindings()
    }

}

private extension CountryDetailViewController {

    private func setupBindings() {
        self.saveCountryButton.rx
            .tap
            .bind {
                self.saveCountry()
            }
            .disposed(by: self.disposeBag)
    }

    @objc func saveCountry() {
        let actionSheet = UIAlertController(
            title: "Choose Option",
            message: "Please select where country should be stored",
            preferredStyle: .actionSheet)
        for store in self.viewModel.stores {
            actionSheet.addAction(UIAlertAction(title: store.rawValue, style: .default, handler: { _ in
                self.didSelectStore(store)
            }))
        }
        self.present(actionSheet, animated: true, completion: nil)
    }

}

private extension CountryDetailViewController {

    func didSelectStore(_ store: Store) {
        self.viewModel.pickStore(store)
    }

    func setupView() {
        self.view.backgroundColor = .white
        self.addSubviews()
        self.addConstraints()
    }

    func addSubviews() {
        self.view.addSubview(self.saveCountryButton)
    }

    func addConstraints() {
        let constraints: [NSLayoutConstraint] = [
            self.saveCountryButton.heightAnchor.constraint(equalToConstant: 50.0),
            self.saveCountryButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.saveCountryButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.saveCountryButton.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
