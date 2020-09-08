import Foundation
import UIKit

protocol CountryListTableViewCellType: AnyObject {
    func setupView(forCountry country: Country)
}

class CountryListTableViewCell: UITableViewCell {

    private static let cellPrimaryFont = UIFont.systemFont(ofSize: 18.0)
    private static let cellSecondaryFont = UIFont.boldSystemFont(ofSize: 16.0)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

extension CountryListTableViewCell: CountryListTableViewCellType {

    func setupView(forCountry country: Country) {
        self.textLabel?.text = country.name
        self.detailTextLabel?.text = country.code
        self.textLabel?.font = CountryListTableViewCell.cellPrimaryFont
        self.detailTextLabel?.font = CountryListTableViewCell.cellSecondaryFont
    }

}
