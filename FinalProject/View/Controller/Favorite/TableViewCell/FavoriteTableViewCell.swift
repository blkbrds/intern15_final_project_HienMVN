import UIKit
import SDWebImage

final class FavoriteTableViewCell: UITableViewCell {

	// MARK: - Outlets
	@IBOutlet weak private var addressLabel: UILabel!
	@IBOutlet weak private var favoriteImageView: UIImageView!
	@IBOutlet weak private var nameLabel: UILabel!

	@IBOutlet weak private var ratingView: RatingView!
	@IBOutlet weak private var timeOpenLabel: UILabel!
	// MARK: - Properties
	var viewModel: FavoriteTableViewCellModel? {
		didSet {
			updateTableViewCell()
		}
	}

	// MARK: - Private Methods
	private func updateTableViewCell() {
		guard let viewModel = viewModel else { return }
		addressLabel.text = viewModel.address
		nameLabel.text = viewModel.locationName
		guard let rating = viewModel.rating,
			let prefix = viewModel.prefix,
			let suffix = viewModel.suffix else { return }
		ratingView.hightlighRating = rating / 2
		timeOpenLabel.text = viewModel.timeOpen
		favoriteImageView.sd_setImage(with: URL(string: prefix + "100x100" + suffix), placeholderImage: #imageLiteral(resourceName: "dsad"))
	}
}
