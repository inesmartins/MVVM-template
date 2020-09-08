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
        button.addTarget(self,
                         action: #selector(self.handleSaveCountryButtonClick), for: .touchUpInside)
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("Save Country", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    // MARK: - UIViewController Properties

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
    }

}

extension CountryDetailViewController: UIActionSheetDelegate {

    @objc func handleSaveCountryButtonClick() {
        let actionSheet = UIAlertController(title: "Choose Option",
                                            message: "Please select where country should be stored",
                                            preferredStyle: .actionSheet)
        for store in self.viewModel.stores {
            actionSheet.addAction(UIAlertAction(title: store.rawValue, style: .default, handler: { _ in
                self.didSelectStore(store)
            }))
        }
        self.present(actionSheet, animated: true, completion: nil)
    }

    private func didSelectStore(_ store: Store) {
        self.viewModel.pickStore(store)
    }

    func showSaveResult(_ result: Bool) {
        DispatchQueue.main.async {
            self.view.makeToast(result ? "Saved" : "Not Saved", duration: 0.5, position: .top)
        }
    }

    func showSavedCountry(_ country: Country) {
        DispatchQueue.main.async {
            self.view.makeToast("Saved Country: \(country.name) - \(country.code)", duration: 1.0, position: .top)
        }
    }

}

extension CountryDetailViewController {

    func setupView() {
        self.addSubviews()
        self.addConstraints()
    }

    func addSubviews() {
        self.view.addSubview(self.saveCountryButton)
    }

    func addConstraints() {
        let constraints: [NSLayoutConstraint] = [
            self.saveCountryButton.heightAnchor.constraint(equalToConstant: 50.0),
            self.saveCountryButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.saveCountryButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            self.saveCountryButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
