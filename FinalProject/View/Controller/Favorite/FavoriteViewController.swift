import UIKit

final class FavoriteViewController: ViewController {

	@IBOutlet weak var tableView: UITableView!
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func setupUI() {
		title = "Favorite"
		let nib = UINib(nibName: Config.favoriteTableViewCell, bundle: .main)
		tableView.register(nib, forCellReuseIdentifier: Config.favoriteTableViewCell)
		tableView.dataSource = self
		tableView.delegate = self
		let deleteAllBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAll))
		self.navigationItem.rightBarButtonItem = deleteAllBarButtonItem
	}
	@objc func deleteAll() {

	}
}

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

extension FavoriteViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return Config.heightForRow
	}
}
extension FavoriteViewController {
	struct Config {
		static var favoriteTableViewCell = "FavoriteTableViewCell"
		static var numberOfRow: Int = 10
		static var heightForRow: CGFloat = 100
	}
}
