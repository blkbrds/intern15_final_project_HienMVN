import UIKit

final class FavoriteViewController: ViewController {

	// MARK: - Outlets
	@IBOutlet weak var tableView: UITableView!

	// MARK: - Properties
	var viewModel: FavoriteViewControllerModel?

	// MARK: - Life Cycle
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		viewModel?.fetchDataRealm(completion: { (success) in
			if success {
				tableView.reloadData()
			} else {
				print("Error: Can't reload 🐥")
			}
		})
	}

	// MARK: - Override Method
	override func setupUI() {
		title = "Favorite"
		let nib = UINib(nibName: Config.favoriteTableViewCell, bundle: .main)
		tableView.register(nib, forCellReuseIdentifier: Config.favoriteTableViewCell)
		tableView.dataSource = self
		tableView.delegate = self

		let deleteAllBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAllDataRealm))
		deleteAllBarButtonItem.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
		self.navigationItem.rightBarButtonItem = deleteAllBarButtonItem
	}

	// MARK: - Action
	@objc func deleteAllDataRealm() {
		guard let viewModel = viewModel else { return }
		viewModel.deleteAllDataRealm { (success) in
			if success {
				tableView.reloadData()
			} else {
				print("Error: Can't deleted 🐥")
			}
		}
	}
}

// MARK: - UITableViewDataSource
extension FavoriteViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let viewModel = viewModel else { return 0 }
		return viewModel.listItemFavorite?.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: Config.favoriteTableViewCell, for: indexPath) as? FavoriteTableViewCell,
			let viewModel = viewModel else {
				fatalError("Imposible case")
		}
		cell.viewModel = viewModel.getCellViewModel(at: indexPath)
		return cell
	}
}

// MARK: - UITableViewDelegate
extension FavoriteViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return Config.heightForRow
	}
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			tableView.beginUpdates()
			guard let viewModel = viewModel else { return }
			viewModel.deleteObjectRealm(at: indexPath.row) { (success) in
				if success {
					tableView.deleteRows(at: [indexPath], with: .fade)
					tableView.endUpdates()
					tableView.reloadData()
				} else {
					print("Error: Can't deleted 🐥")
				}
			}
		}
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
