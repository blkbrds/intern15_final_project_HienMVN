import UIKit
import SDWebImage

final class LocationCollectionViewCell: UICollectionViewCell {

	// MARK: - Outlet
	@IBOutlet weak private var locationImageView: UIImageView!
	@IBOutlet weak private var addressLabel: UILabel!
	@IBOutlet weak private var locationNameLabel: UILabel!

	// MARK: - Properties
	private let backgroundImageView = UIImageView()
	var viewModel = LocationViewCellModel() {
		didSet {
			updateView()
		}
	}

	// MARK: - Life Cycle
	override func awakeFromNib() {
		super.awakeFromNib()
		setBackground()
	}

	// MARK: - Private Method
	private func setBackground() {
		addSubview(backgroundImageView)
		backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
		backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
		backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
		backgroundImageView.alpha = 0.7
		sendSubviewToBack(backgroundImageView)
	}

	private func updateView() {
		addressLabel.text = viewModel.country
		locationNameLabel.text = viewModel.locationName

		guard let locationImageURL = viewModel.locationImageURL,
			let suffix = viewModel.suffix, let prefix = viewModel.prefix else { return }
		locationImageView.sd_setImage(with: URL(string: locationImageURL + "64.png"), placeholderImage: #imageLiteral(resourceName: "icons8-star-96"))
		backgroundImageView.sd_setImage(with: URL(string: prefix + "414x414" + suffix), placeholderImage: #imageLiteral(resourceName: "dsad"))
	}
}
