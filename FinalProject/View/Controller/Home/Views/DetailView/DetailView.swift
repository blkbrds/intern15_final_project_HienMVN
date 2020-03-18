import UIKit

final class DetailView: UIView {

	// MARK: - Outlet
	@IBOutlet weak private var detailCollectionView: UICollectionView!
	@IBOutlet weak private var locationNameLabel: UILabel!
	@IBOutlet weak private var addressLabel: UILabel!

	// MARK: - Properties
	var viewmodel = DetailViewModel() {
		didSet {
			detailCollectionView.reloadData()
		}
	}
	private let locationCollectionViewCell = "LocationCollectionViewCell"

	// MARK: - Life Cycle
	override func awakeFromNib() {
		super.awakeFromNib()
		loadNib()
	}

	// MARK: - Private Method
	private func loadNib() {
		let nib = UINib(nibName: locationCollectionViewCell, bundle: .main)
		detailCollectionView.register(nib, forCellWithReuseIdentifier: locationCollectionViewCell)
		detailCollectionView.dataSource = self
	}
}

// MARK: - UICollectionViewDataSource
extension DetailView: UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewmodel.numberOfIteam()
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: locationCollectionViewCell, for: indexPath) as? LocationCollectionViewCell else {
			return UICollectionViewCell()
		}
		cell.viewModel = viewmodel.updateViewModelForCell(at: indexPath)
		return cell
	}
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: UIScreen.main.bounds.width / 2 - 20, height: UIScreen.main.bounds.height / 3)
	}

	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		cell.alpha = 0
		cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
		UIView.animate(withDuration: 1) {
			cell.alpha = 1
			cell.transform = .identity
		}
	}
}
