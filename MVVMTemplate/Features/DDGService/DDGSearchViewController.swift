import Foundation
import UIKit
import Toast_Swift

protocol DDGSearchViewControllerType: AnyObject {
    func showResult(_ searchResult: SearchResult)
    func showNoResultsFound()
}

final class DDGSearchViewController: KeyboardAwareViewController {

    // MARK: - UIViewController Properties

    private var searchTerm: String?

    // MARK: - UI components

    private lazy var textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    private lazy var searchButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Search on DuckDuckGo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(self.handleSearchButtonClick), for: .touchUpInside)
        return button
    }()

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

extension DDGSearchViewController: DDGSearchViewControllerType {

    func showNoResultsFound() {
        self.view.makeToast("No Results Found")
    }

    func showResult(_ searchResult: SearchResult) {
        debugPrint(searchResult)
    }

}

extension DDGSearchViewController: UITextFieldDelegate {

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {

        self.searchTerm = (string == "" && textField.text?.count == 1) ? nil : textField.text
        self.updateSearchButton(enabled: self.searchTerm != nil)
        return true
    }
}

private extension DDGSearchViewController {

    func setupViews() {
        self.view.backgroundColor = .white
        self.addSubviews()
        self.addConstraints()
    }

    func addSubviews() {
        self.view.addSubview(self.textField)
        self.view.addSubview(self.searchButton)
    }

    @objc func handleSearchButtonClick() {
        if let searchTerm = self.textField.text {
            // todo: implement
        }
    }

    func addConstraints() {
        let constraints = [
            self.textField.heightAnchor.constraint(equalToConstant: 50.0),
            self.textField.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            self.textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            self.textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0),
            self.searchButton.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.searchButton.heightAnchor.constraint(equalToConstant: 50.0),
            self.searchButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.searchButton.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50.0)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func updateSearchButton(enabled: Bool) {
        self.searchButton.alpha = enabled ? 1.0 : 0.2
    }

}
