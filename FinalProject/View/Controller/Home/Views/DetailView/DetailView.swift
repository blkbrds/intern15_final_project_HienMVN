import UIKit

final class DetailView: UIView {

	// MARK: - Outlet
	@IBOutlet weak private var detailCollectionView: UICollectionView!


	// MARK: - Properties
	private let locationCollectionViewCell = "LocationCollectionViewCell"
	var viewModel: DetailViewModel? {
		didSet {
			updateView()
		}
	}

	// MARK: - Life Cycle
	override func awakeFromNib() {
		super.awakeFromNib()
		configCollectionView()
	}

	// MARK: - Private Method
	private func configCollectionView() {
		let nib = UINib(nibName: locationCollectionViewCell, bundle: .main)
		detailCollectionView.register(nib, forCellWithReuseIdentifier: locationCollectionViewCell)
		detailCollectionView.dataSource = self
	}

	private func updateView() {
		detailCollectionView.reloadData()
	}

	// MARK: - Public Method
	func scrollCollectionView(to venue: VenueHome) {
		guard let viewModel = viewModel,
			let indexPath = viewModel.getIndexPathVenues(id: venue.id) else { return }
		detailCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
	}
}

// MARK: - UICollectionViewDataSource
extension DetailView: UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let numberItems = viewModel?.numberOfItem() else { return 0 }
		return numberItems
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: locationCollectionViewCell, for: indexPath) as? LocationCollectionViewCell else {
			return UICollectionViewCell()
		}
		if let viewModel = viewModel {
			cell.viewModel = viewModel.getLocationViewCellModel(at: indexPath)
		}
		return cell
	}
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: UIScreen.main.bounds.width / 2 - 20, height: UIScreen.main.bounds.height / 2)
	}
}
