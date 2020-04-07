import UIKit

final class DetailView: UIView {

	// MARK: - Outlet
	@IBOutlet weak private var detailCollectionView: UICollectionView!
	@IBOutlet weak private var locationNameLabel: UILabel!
	@IBOutlet weak private var addressLabel: UILabel!

	// MARK: - Properties
	var viewModel: DetailViewModel? {
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

	// TODO: scroll collection by internal func 
	func scrollCollectionView(to venue: VenueHome) {
		guard let viewModel = viewModel else { return }
		guard let index = viewModel.venues.firstIndex(of: venue) else { return }
		let indexPath = IndexPath(row: index, section: 0)
		detailCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
	}
}

// MARK: - UICollectionViewDataSource
extension DetailView: UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel?.numberOfIteam() ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: locationCollectionViewCell, for: indexPath) as? LocationCollectionViewCell else {
			return UICollectionViewCell()
		}
		if let viewmodel = viewModel {
			cell.viewModel = viewmodel.updateInformationForCell(at: indexPath)
		}
		return cell
	}
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: UIScreen.main.bounds.width / 2 - 20, height: UIScreen.main.bounds.height / 2)
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
