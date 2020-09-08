import UIKit

class CountryListViewController: UIViewController {

    // MARK: - Class properties

    private static let tableCellId = "tableCell"

    // MARK: - UIViewController Properties

    private var countries = [Country]()

    // MARK: - UI components

    private lazy var countriesTable = UITableView(frame: .zero)
    private lazy var storeSelector = UIPickerView(frame: .zero)
    private lazy var saveCountryButton = UIButton(frame: .zero)
    private lazy var getSavedCountryButton = UIButton(frame: .zero)

    // MARK: - UIViewController Lifecycle

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
        // TODO: implement
    }

}

extension CountryListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = self.countries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryListViewController.tableCellId)
            as? CountryListTableViewCell ?? CountryListTableViewCell()
        cell.setupView(forCountry: country)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = self.countries[indexPath.row]
        // TODO: implement
    }

    // Added to minimize the complexity of height calculations, improving UITableView performance
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}

extension CountryListViewController {

    func updateCountryList(_ countries: [Country]) {
        self.countries = countries
        DispatchQueue.main.async {
            self.countriesTable.reloadData()
        }
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

private extension CountryListViewController {

    func setupView() {
        self.addSubviews()
        self.setupUIComponents()
        self.addConstraints()
    }

    func setupUIComponents() {

        // countriesTable UITableView
        self.countriesTable.translatesAutoresizingMaskIntoConstraints = false
        self.countriesTable.dataSource = self
        self.countriesTable.delegate = self
        self.countriesTable.register(
            CountryListTableViewCell.self,
            forCellReuseIdentifier: CountryListViewController.tableCellId)

        // storeSelector UIPickerView
        self.storeSelector.translatesAutoresizingMaskIntoConstraints = false
        self.storeSelector.dataSource = self
        self.storeSelector.delegate = self
        self.storeSelector.backgroundColor = .white

        // saveCountryButton UIButton
        self.saveCountryButton.translatesAutoresizingMaskIntoConstraints = false
        self.saveCountryButton.addTarget(
            self,
            action: #selector(self.handleSaveCountryButtonClick), for: .touchUpInside)
        self.saveCountryButton.backgroundColor = .green
        self.saveCountryButton.setTitle("Save Country", for: .normal)
        self.saveCountryButton.setTitleColor(.black, for: .normal)

        // getSavedCountryButton UIButton
        self.getSavedCountryButton.translatesAutoresizingMaskIntoConstraints = false
        self.getSavedCountryButton.addTarget(self,
                                             action: #selector(self.handleGetSavedCountryButtonClick),
                                             for: .touchUpInside)
        self.getSavedCountryButton.backgroundColor = .gray
        self.getSavedCountryButton.setTitle("Get Saved Country", for: .normal)
        self.getSavedCountryButton.setTitleColor(.black, for: .normal)
    }

    @objc func handleSaveCountryButtonClick() {
        // TODO
    }

    @objc func handleGetSavedCountryButtonClick() {
        // TODO
    }

    func addSubviews() {
        self.view.addSubview(self.countriesTable)
        self.view.addSubview(self.storeSelector)
        self.view.addSubview(self.saveCountryButton)
        self.view.addSubview(self.getSavedCountryButton)
    }

    func addConstraints() {
        let constraints: [NSLayoutConstraint] = [
            self.countriesTable.topAnchor.constraint(equalTo: self.view.topAnchor),
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
            self.getSavedCountryButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
