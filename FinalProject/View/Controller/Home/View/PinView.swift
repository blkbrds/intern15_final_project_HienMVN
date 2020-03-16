import Foundation
import MapKit

final class PinView: MKPinAnnotationView {

	// MARK: - Properties
	private var imageView: UIImageView!

	// MARK: - Init
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

		imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
		imageView.image = #imageLiteral(resourceName: "pin")
		addSubview(self.imageView)

		imageView.layer.cornerRadius = 5.0
		imageView.layer.masksToBounds = true
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override var image: UIImage? {
		get {
			return imageView.image
		}

		set {
			if imageView != nil {
				imageView.image = newValue
			}
		}
	}
}
