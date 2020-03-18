import UIKit
import SDWebImage

class LocationCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var locationImage: UIImageView!
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var locationNameLabel: UILabel!

	let backgroundImageView = UIImageView()
	var viewModel = LocationViewCellModel() {
		didSet {
			updateView()
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		setBackground()
	}

	func setBackground() {
		self.addSubview(backgroundImageView)
		backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
		backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
		backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
		backgroundImageView.image = #imageLiteral(resourceName: "danang_image")
		self.sendSubviewToBack(backgroundImageView)
	}

	func updateView() {
		addressLabel.text = viewModel.address
		locationNameLabel.text = viewModel.locationName
		locationImage.sd_setImage(with: URL(string: viewModel.locationImageURL + "32.png"), placeholderImage: #imageLiteral(resourceName: "icons8-star-30"))
	}
}
