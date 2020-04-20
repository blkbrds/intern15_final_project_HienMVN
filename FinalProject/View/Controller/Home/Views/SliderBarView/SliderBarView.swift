import Foundation
import UIKit

// MARK: Protocol
protocol SliderBarViewDelegate: class {
	func sidebarDidSelectRow(typeOfLocation: String)
}

class SliderBarView: UIView {

	// MARK: Properties
	private var myTableView = UITableView()
	private var titles: [String] = ["Menu ", "Restaurant", "School", "Hotel", "Coffee", "Bar", "Bakery"]

	weak var delegate: SliderBarViewDelegate?

	// MARK: Override Init
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.598432149)
		configTableView()
	}

	// MARK: Required Init
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Private Methods
	private func configTableView() {
		setupViews()
		myTableView.dataSource = self
		myTableView.delegate = self
		myTableView.register(UITableViewCell.self, forCellReuseIdentifier: Config.tableCelldetifier)
		myTableView.showsVerticalScrollIndicator = false
		myTableView.backgroundColor = UIColor.clear
	}

	private func setupViews() {
		self.addSubview(myTableView)
		myTableView.translatesAutoresizingMaskIntoConstraints = false
		myTableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		myTableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		myTableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		myTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}
}

// MARK: UITableViewDataSource
extension SliderBarView: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return titles.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Config.tableCelldetifier, for: indexPath)
		cell.backgroundColor = .clear
		cell.selectionStyle = .none
		if indexPath.row == 0 {
			cell.backgroundColor = .clear
			
			let cellLabel = UILabel(frame: CGRect(x: Config.xOrigin, y: cell.frame.height / 2 - Config.spacing, width: Config.widthLabel, height: Config.hightLabel))
			cell.addSubview(cellLabel)
			cellLabel.text = titles[indexPath.row]
			cellLabel.font = UIFont.systemFont(ofSize: Config.fontOfSize)
			cellLabel.textColor = UIColor.white
		} else {
			cell.textLabel?.text = titles[indexPath.row]
			cell.textLabel?.textColor = UIColor.white
		}
		return cell
	}
}

// MARK: UITableViewDelegate
extension SliderBarView: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 0 {
			return
		} else {
			delegate?.sidebarDidSelectRow(typeOfLocation: titles[indexPath.row])
		}
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return Config.hightForRowAtZero
		} else {
			return Config.hightForRow
		}
	}
}

// MARK: Config
extension SliderBarView {
	struct Config {
		static var tableCelldetifier: String = "Cell"
		static var hightForRowAtZero: CGFloat = 43
		static var hightForRow: CGFloat = 60
		static var hightImage: CGFloat = 30
		static var widthImage: CGFloat = 30
		static var spacingX: CGFloat = 12
		static var spacingY: CGFloat = 8
		static var spacing: CGFloat = 15
		static var basicWidth: CGFloat = 250
		static var fontOfSize: CGFloat = 30
		static var widthLabel: CGFloat = 250
		static var hightLabel: CGFloat = 30
		static var xOrigin: CGFloat = 70
	}
}
