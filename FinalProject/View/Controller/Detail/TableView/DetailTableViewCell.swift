import UIKit

final class DetailTableViewCell: UITableViewCell {

	@IBOutlet weak private  var locationNameLabel: UILabel!
	@IBOutlet weak private var addressLabel: UILabel!
	@IBOutlet weak private var cityLabel: UILabel!
	@IBOutlet weak private var locationImageView: UIImageView!

	var viewModel: DetailTableViewModel? {
		didSet {
			updateTableView()
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		setupUITableView()
	}

	private func updateTableView() {
		addressLabel.text = viewModel?.address
		cityLabel.text = viewModel?.city
		locationNameLabel.text = viewModel?.locationName
		guard let imageURL = viewModel?.imageURL else { return }
		locationImageView.sd_setImage(with: URL(string: imageURL + "64.png"), placeholderImage: #imageLiteral(resourceName: "icons8-hand-drawn-star-100"))
	}

	private func setupUITableView() {
		locationImageView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
		locationImageView.layer.cornerRadius = 5
		locationImageView.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
		locationImageView.layer.shadowOffset = CGSize(width: 0, height: 5.75)
		locationImageView.layer.shadowRadius = 1.75
		locationImageView.layer.shadowOpacity = 0.5
		locationImageView.clipsToBounds = true
		locationImageView.layer.masksToBounds = false
	}
}
