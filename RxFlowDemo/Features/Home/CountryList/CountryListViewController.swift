import UIKit
import RxSwift
import RxFlow
import RxRelay
import Toast_Swift

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
    private lazy var sendDeeplinkButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("Open with notification", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    // MARK: - UIViewController Properties

    private let disposeBag = DisposeBag()
    var viewModel: CountryListViewModel!

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

private extension CountryListViewController {

    private func setupBindings() {
        self.sendDeeplinkButton.rx
            .tap
            .bind {
                self.sendDeeplink()
            }.disposed(by: self.disposeBag)
    }
}

private extension CountryListViewController {

    @objc func sendDeeplink() {
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { (granted, _) in
             guard granted else { return }
             let content = UNMutableNotificationContent()
             content.title = "Notification from RxFlow"
             content.subtitle = "Deeplink use case"
            content.body = "Click to navigate to \(self.viewModel.savedCountry?.name ?? "")"
             let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
             let request = UNNotificationRequest(identifier: "\(UUID())", content: content, trigger: trigger)
             UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
         }
    }

}

extension CountryListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.countries.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = self.viewModel.countries[indexPath.row]
        self.viewModel.pickCountry(withName: country.name)
    }

    // Added to minimize the complexity of height calculations, improving UITableView performance
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

}

extension CountryListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = self.viewModel.countries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryListViewController.tableCellId)
            as? CountryListTableViewCell ?? CountryListTableViewCell()
        cell.setupView(forCountry: country)
        return cell
    }

}

private extension CountryListViewController {

    func setupView() {
        self.addSubviews()
        self.addConstraints()
    }

    func addSubviews() {
        self.view.addSubview(self.countriesTable)
        self.view.addSubview(self.sendDeeplinkButton)
    }

    func addConstraints() {
        let constraints: [NSLayoutConstraint] = [
            self.countriesTable.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.countriesTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.countriesTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.sendDeeplinkButton.topAnchor.constraint(equalTo: self.countriesTable.bottomAnchor, constant: 20.0),
            self.sendDeeplinkButton.heightAnchor.constraint(equalToConstant: 50.0),
            self.sendDeeplinkButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            self.sendDeeplinkButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0),
            self.sendDeeplinkButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20.0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
