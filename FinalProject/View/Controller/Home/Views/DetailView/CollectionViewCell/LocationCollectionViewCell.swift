import UIKit
import SDWebImage

class LocationCollectionViewCell: UICollectionViewCell {

	// MARK: - Outlet
	@IBOutlet weak var locationImage: UIImageView!
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var locationNameLabel: UILabel!

	// MARK: - Properties
	private let backgroundImageView = UIImageView()
	var viewModel = LocationViewCellModel(locationImageURL: "") {
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
		self.addSubview(backgroundImageView)
		backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
		backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
		backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
		backgroundImageView.image = #imageLiteral(resourceName: "anhnhoem")
		self.sendSubviewToBack(backgroundImageView)
	}

	private func updateView() {
		addressLabel.text = viewModel.country
		locationNameLabel.text = viewModel.locationName
		guard let locationImageURL = viewModel.locationImageURL else { return }
		locationImage.sd_setImage(with: URL(string: locationImageURL + "64.png"), placeholderImage: #imageLiteral(resourceName: "icons8-star-100"))
	}
}
