import UIKit

final class FavoriteViewController: ViewController {

	// MARK: - Outlets
	@IBOutlet weak private var tableView: UITableView!

	// MARK: - Properties
	var viewModel: FavoriteViewControllerModel?

	// MARK: - Life Cycle
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		RealmManager.shared.fetchDataRealm(completion: { (success) in
			if success {
				tableView.reloadData()
			} else {
				print("Error: Can't reload ")
			}
		})
	}

	// MARK: - Override Method
	override func setupUI() {
		title = "Favorite"
		let deleteAllBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAllDataRealm))
		deleteAllBarButtonItem.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		self.navigationItem.rightBarButtonItem = deleteAllBarButtonItem
		navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		configTableView()
	}

	// MARK: - Action
	@objc func deleteAllDataRealm() {
		RealmManager.shared.deleteAllDataRealm { (success) in
			if success {
				tableView.reloadData()
			} else {
				print("Error: Can't deleted ")
			}
		}
	}

	private func configTableView() {
		let nib = UINib(nibName: Config.favoriteTableViewCell, bundle: .main)
		tableView.register(nib, forCellReuseIdentifier: Config.favoriteTableViewCell)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.allowsMultipleSelection = true
		tableView.allowsSelectionDuringEditing = true
		let imageBackgrond = UIImageView()
		imageBackgrond.image = #imageLiteral(resourceName: "dsad")
		imageBackgrond.alpha = 0.7
		tableView.backgroundView = imageBackgrond
	}
}

// MARK: - UITableViewDataSource
extension FavoriteViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let numberOfCount = RealmManager.shared.listItemFavorite?.count else { return 0 }
		return numberOfCount
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: Config.favoriteTableViewCell, for: indexPath) as? FavoriteTableViewCell,
			let viewModel = viewModel else {
				fatalError("Imposible case")
		}
		cell.viewModel = viewModel.getFavoriteTableViewCellModel(at: indexPath)
		return cell
	}
}

// MARK: - UITableViewDelegate
extension FavoriteViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			tableView.beginUpdates()
			RealmManager.shared.deleteObjectRealm(at: indexPath.row) { (success) in
				if success {
					tableView.deleteRows(at: [indexPath], with: .fade)
					tableView.endUpdates()
					tableView.reloadData()
				} else {
					print("Error: Can't deleted ")
				}
			}
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let detailVC = DetailViewController()
		detailVC.viewModel = viewModel?.detailViewControllerModel(at: indexPath)
		navigationController?.pushViewController(detailVC, animated: true)
	}
}

// MARK: - Config
extension FavoriteViewController {
	struct Config {
		static var favoriteTableViewCell = "FavoriteTableViewCell"
	}
}
