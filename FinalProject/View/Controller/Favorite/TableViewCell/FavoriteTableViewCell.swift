import UIKit
import SDWebImage

final class FavoriteTableViewCell: UITableViewCell {

	// MARK: - Outlets
	@IBOutlet weak private var addressLabel: UILabel!
	@IBOutlet weak private var favoriteImageView: UIImageView!
	@IBOutlet weak private var nameLabel: UILabel!

	// MARK: - Properties
	var viewModel: FavoriteTableViewCellModel? {
		didSet {
			guard let viewModel = viewModel else { return }
			addressLabel.text = viewModel.address
			nameLabel.text = viewModel.locationName
			favoriteImageView.sd_setImage(with: URL(string: viewModel.prefix + "100x100" + viewModel.suffix), placeholderImage: #imageLiteral(resourceName: "paris"))
		}
	}

	// MARK: - Life Cycle
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}
