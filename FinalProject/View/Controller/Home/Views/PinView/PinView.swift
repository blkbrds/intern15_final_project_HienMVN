import Foundation
import MapKit

final class PinView: MKPinAnnotationView {

	// MARK: - Properties
	private var imageView: UIImageView!

	// MARK: - Init
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		frame = CGRect(x: 0, y: 0, width: 20, height: 40)
		imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 40))
		imageView.image = #imageLiteral(resourceName: "pin")
		addSubview(self.imageView)
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
