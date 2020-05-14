import UIKit

class RatingView: UIStackView {

	var rating: Int = 5
	var hightlighRating: Int = 3 {
		didSet {
			updateUI()
		}
	}
	var imageStar: UIImage? = #imageLiteral(resourceName: "icons8-star")
	var highlightImage: UIImage? = #imageLiteral(resourceName: "icons8-star-fill")
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
		updateUI()
	}

	required init(coder: NSCoder) {
		super.init(coder: coder)
		setupUI()
		updateUI()
	}

	private func setupUI() {
		clearSubViews()
		for _ in 0..<rating {
			let image = UIImageView(image: imageStar)
			addArrangedSubview(image)
		}
	}

	private func updateUI() {
		for i in 0..<subviews.count {
			if let view = subviews[i] as? UIImageView {
				if i < hightlighRating {
					view.image = highlightImage
				} else {
					view.image = imageStar
				}
			}
		}
	}

}
