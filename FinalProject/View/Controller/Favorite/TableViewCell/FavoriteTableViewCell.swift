import UIKit
import SDWebImage

final class FavoriteTableViewCell: UITableViewCell {

	// MARK: - Outlets
	@IBOutlet weak private var addressLabel: UILabel!
	@IBOutlet weak private var favoriteImageView: UIImageView!
	@IBOutlet weak private var nameLabel: UILabel!
	@IBOutlet weak private var backgroundImage: UIImageView!
	@IBOutlet weak private var ratingLabel: UILabel!
	@IBOutlet weak private var likeLabel: UILabel!
	@IBOutlet weak private var timeOpenLabel: UILabel!
	// MARK: - Properties
	var viewModel: FavoriteTableViewCellModel? {
		didSet {
			updateTableViewCell()
		}
	}

	// MARK: - Life Cycle
	override func awakeFromNib() {
		super.awakeFromNib()
		setupTableView()
	}

	// MARK: - Private Methods
	private func updateTableViewCell() {
		guard let viewModel = viewModel else { return }
		addressLabel.text = viewModel.address
		nameLabel.text = viewModel.locationName
		guard let rating = viewModel.rating,
			let like = viewModel.like,
			let prefix = viewModel.prefix,
			let suffix = viewModel.suffix else { return }
		ratingLabel.text = String(rating)
		likeLabel.text = String(like)
		timeOpenLabel.text = viewModel.timeOpen
		favoriteImageView.sd_setImage(with: URL(string: prefix + "100x100" + suffix), placeholderImage: #imageLiteral(resourceName: "dsad"))
	}

	private func setupTableView() {
		backgroundImage.backgroundColor = #colorLiteral(red: 0.8795893192, green: 0.9392406344, blue: 0.9337235689, alpha: 1)
		backgroundImage.layer.cornerRadius = 5
		backgroundImage.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
		backgroundImage.layer.shadowOffset = CGSize(width: 0, height: 5.75)
		backgroundImage.layer.shadowRadius = 1.75
		backgroundImage.layer.shadowOpacity = 0.5
		backgroundImage.clipsToBounds = true
		backgroundImage.layer.masksToBounds = false
	}
}
