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
        self.setupView()
        _ = Observable<Int>
            .interval(.seconds(5), scheduler: MainScheduler.instance)
            .takeUntil(self.rx.deallocating)
            .map { _ in return AppStep.fakeStep }
            .bind(to: self.steps)
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
        self.viewModel.pickCountry(withName: country.name)
    }

    // Added to minimize the complexity of height calculations, improving UITableView performance
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

}

private extension CountryListViewController {

    func setupView() {
        self.addSubviews()
        self.addConstraints()
    }

    func addSubviews() {
        self.view.addSubview(self.countriesTable)
    }

    func addConstraints() {
        let constraints: [NSLayoutConstraint] = [
            self.countriesTable.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.countriesTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.countriesTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.countriesTable.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
