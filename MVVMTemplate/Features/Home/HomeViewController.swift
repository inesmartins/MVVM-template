import Foundation
import UIKit
import RxSwift

final class HomeViewController: UIViewController {

    // MARK: - UI components

    private lazy var buttonsContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    private lazy var deviceInfoButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(self.handleDeviceInfoButtonClick),
                         for: .touchUpInside)
        button.setTitle("Search on DuckDuckGo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 2
        return button
    }()
    private lazy var countryListButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(self.handleCountryListButtonClick),
                         for: .touchUpInside)
        button.setTitle("See Country List", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 2
        return button
    }()
    
    // MARK: - Properties

    let disposeBag = DisposeBag()
    let viewModel: HomeViewModel
    let ddgService: DDGServiceType

    // MARK: - Lifecycle Methods

    init(viewModel: HomeViewModel, ddgService: DDGServiceType) {
        self.viewModel = viewModel
        self.ddgService = ddgService
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

private extension HomeViewController {

    func setupView() {
        self.view.backgroundColor = .white
        self.addSubviews()
        self.addConstraints()
    }

    func addSubviews() {
        self.view.addSubview(self.buttonsContainer)
        self.buttonsContainer.addSubview(self.deviceInfoButton)
        self.buttonsContainer.addSubview(self.countryListButton)
    }

    func addConstraints() {
        let constraints: [NSLayoutConstraint] = [

            self.buttonsContainer.heightAnchor.constraint(equalToConstant: 120.0),
            self.buttonsContainer.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            self.buttonsContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            self.buttonsContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0),

            self.deviceInfoButton.heightAnchor.constraint(equalToConstant: 50.0),
            self.deviceInfoButton.topAnchor.constraint(equalTo: self.buttonsContainer.topAnchor),
            self.deviceInfoButton.leadingAnchor.constraint(equalTo: self.buttonsContainer.leadingAnchor),
            self.deviceInfoButton.trailingAnchor.constraint(equalTo: self.buttonsContainer.trailingAnchor),

            self.countryListButton.heightAnchor.constraint(equalToConstant: 50.0),
            self.countryListButton.topAnchor.constraint(equalTo: self.deviceInfoButton.bottomAnchor, constant: 20.0),
            self.countryListButton.leadingAnchor.constraint(equalTo: self.buttonsContainer.leadingAnchor),
            self.countryListButton.trailingAnchor.constraint(equalTo: self.buttonsContainer.trailingAnchor),
            self.countryListButton.bottomAnchor.constraint(equalTo: self.buttonsContainer.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    @objc func handleDeviceInfoButtonClick() {
        // todo: implement
    }

    @objc func handleCountryListButtonClick() {
        // todo: implement
    }
}
