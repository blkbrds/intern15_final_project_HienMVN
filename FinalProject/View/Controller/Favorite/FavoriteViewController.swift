import UIKit

final class FavoriteViewController: ViewController {

	// MARK: - Outlets
	@IBOutlet weak var tableView: UITableView!

	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	// MARK: - Override Method
	override func setupUI() {
		title = "Favorite"
		let nib = UINib(nibName: Config.favoriteTableViewCell, bundle: .main)
		tableView.register(nib, forCellReuseIdentifier: Config.favoriteTableViewCell)
		tableView.dataSource = self
		tableView.delegate = self
		let deleteAllBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAll))
		navigationItem.rightBarButtonItem = deleteAllBarButtonItem
	}

	// MARK: - Action
	@objc func deleteAll() {

	}
}

// MARK: - UITableViewDataSource
extension FavoriteViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Config.numberOfRow
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: Config.favoriteTableViewCell, for: indexPath) as? FavoriteTableViewCell else {
			return UITableViewCell(style: .default, reuseIdentifier: Config.favoriteTableViewCell)
		}
		return cell
	}
}

// MARK: - UITableViewDelegate
extension FavoriteViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return Config.heightForRow
	}
}
// MARK: - Config
extension FavoriteViewController {
	struct Config {
		static var favoriteTableViewCell = "FavoriteTableViewCell"
		static var numberOfRow: Int = 10
		static var heightForRow: CGFloat = 100
	}
}
