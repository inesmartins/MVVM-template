import UIKit
import RxFlow
import RxRelay
import Toast_Swift

protocol CountryListViewControllerType: AnyObject {
    func showSaveResult(_ result: Bool)
    func showSavedCountry(_ country: Country)
}

class CountryListViewController: UIViewController, ViewModelBased {

    // MARK: - Class properties

    private static let tableCellId = "tableCell"

    // MARK: - UI components

    private lazy var countriesTable: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(
            CountryListTableViewCell.self,
            forCellReuseIdentifier: CountryListViewController.tableCellId)
        return table
    }()
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
    private lazy var getSavedCountryButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                        action: #selector(self.handleGetSavedCountryButtonClick),
                        for: .touchUpInside)
        button.backgroundColor = .gray
        button.setTitle("Get Saved Country", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    // MARK: - UIViewController Properties

    var viewModel: CountryListViewModel!
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
        // TODO: refactor
        //self.delegate.viewWasLoaded(on: self)
        self.setupView()
    }

}

extension CountryListViewController: UIPickerViewDelegate, UIPickerViewDataSource {

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
        // TODO: refactor
        //self.delegate.didSelectStore(Store.allCases[row])
    }

}

extension CountryListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.countries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = self.viewModel.countries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryListViewController.tableCellId)
            as? CountryListTableViewCell ?? CountryListTableViewCell()
        cell.setupView(forCountry: country)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = self.viewModel.countries[indexPath.row]
        // TODO: refactor
        //self.delegate.didSelectCountry(country)
    }

    // Added to minimize the complexity of height calculations, improving UITableView performance
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}

extension CountryListViewController: CountryListViewControllerType {

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

private extension CountryListViewController {

    func setupView() {
        self.addSubviews()
        self.addConstraints()
    }

    @objc func handleSaveCountryButtonClick() {
        // TODO: refactor
        //self.delegate.didClickSaveCountry()
    }

    @objc func handleGetSavedCountryButtonClick() {
        // TODO: refactor
        //self.delegate.didClickLoadSavedCountry()
    }

    func addSubviews() {
        self.view.addSubview(self.countriesTable)
        self.view.addSubview(self.storeSelector)
        self.view.addSubview(self.saveCountryButton)
        self.view.addSubview(self.getSavedCountryButton)
    }

    func addConstraints() {
        let constraints: [NSLayoutConstraint] = [
            self.countriesTable.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.countriesTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.countriesTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.storeSelector.heightAnchor.constraint(equalToConstant: 120.0),
            self.storeSelector.topAnchor.constraint(equalTo: self.countriesTable.bottomAnchor),
            self.storeSelector.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.storeSelector.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.saveCountryButton.heightAnchor.constraint(equalToConstant: 50.0),
            self.saveCountryButton.topAnchor.constraint(equalTo: self.storeSelector.bottomAnchor),
            self.saveCountryButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.saveCountryButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.getSavedCountryButton.heightAnchor.constraint(equalToConstant: 50.0),
            self.getSavedCountryButton.topAnchor.constraint(equalTo: self.saveCountryButton.bottomAnchor),
            self.getSavedCountryButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.getSavedCountryButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.getSavedCountryButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
