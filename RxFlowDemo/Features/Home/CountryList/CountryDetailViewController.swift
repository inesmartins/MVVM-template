import UIKit
import Reusable
import RxFlow
import RxSwift
import RxCocoa

class CountryDetailViewController: UIViewController, ViewModelBased {

    // MARK: - UI components

    private lazy var storeSelector: UIPickerView = {
        let picker = UIPickerView(frame: .zero)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.dataSource = self
        picker.delegate = self
        picker.backgroundColor = .white
        return picker
    }()
    private lazy var saveCountryButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(self.handleSaveCountryButtonClick), for: .touchUpInside)
        button.backgroundColor = .green
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

extension CountryDetailViewController {

    @objc func handleSaveCountryButtonClick() {
        // TODO: refactor
        //self.delegate.didClickSaveCountry()
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

extension CountryDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Store.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Store.allCases[row].rawValue
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.viewModel.pickStore(Store.allCases[row])
    }

}

extension CountryDetailViewController {

    func setupView() {
        self.addSubviews()
        self.addConstraints()
    }

    func addSubviews() {
        self.view.addSubview(self.storeSelector)
        self.view.addSubview(self.saveCountryButton)
    }

    func addConstraints() {
        let constraints: [NSLayoutConstraint] = [
            self.storeSelector.heightAnchor.constraint(equalToConstant: 120.0),
            self.storeSelector.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.storeSelector.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.storeSelector.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.saveCountryButton.heightAnchor.constraint(equalToConstant: 50.0),
            self.saveCountryButton.topAnchor.constraint(equalTo: self.storeSelector.bottomAnchor),
            self.saveCountryButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.saveCountryButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.saveCountryButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
