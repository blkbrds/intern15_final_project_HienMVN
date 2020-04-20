import UIKit
import MapKit
import SDWebImage

final class DetailViewController: ViewController {

	// MARK: Outlet

	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var cityLabel: UILabel!

	@IBOutlet weak private var favoriteButton: UIButton!
	@IBOutlet weak private var timeOpenLabel: UILabel!
	@IBOutlet weak private var locationImageView: UIImageView!
	@IBOutlet weak private var discriptionLabel: UILabel!
	@IBOutlet weak private var likeLabel: UILabel!
	@IBOutlet weak private var ratingLabel: UILabel!
	@IBOutlet weak private var locationNameLabel: UILabel!
	@IBOutlet weak private var addressLabel: UILabel!
	// MARK: Properties
	var viewModel: DetailViewControllerModel?

	// MARK: Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.delegate = self
		center(location: mapView.userLocation.coordinate)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		// getAPIForDetail()
		makeNavigationBarTransparent()
	}

	func makeNavigationBarTransparent(isTranslucent: Bool = true) {
		if let navBar = navigationController?.navigationBar {
			let blankImage = UIImage()
			navBar.setBackgroundImage(blankImage, for: .default)
			navBar.shadowImage = blankImage
			navBar.isTranslucent = isTranslucent
		}
		let rightButon = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-back-50"), style: .plain, target: self, action: #selector(backToHomeTouchUpInside))
		navigationItem.leftBarButtonItem = rightButon
	}

	@objc func backToHomeTouchUpInside () {
		navigationController?.popToRootViewController(animated: true)
	}

	// MARK: Private Methods
	override func setupUI() {
		guard let item = viewModel?.venueDetail else { return }
		locationNameLabel.text = item.name
		addressLabel.text = item.address
		cityLabel.text = item.city
		ratingLabel.text = String(item.rating)
		likeLabel.text = String(item.countOfLike) + "Like"
		discriptionLabel.text = item.descriptionText
		if let prefix = item.prefix, let sufix = item.suffix {
			let url = prefix + "414x414" + sufix
			locationImageView.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "dsad") )
		}
		timeOpenLabel.text = item.openTime
		favoriteButton.isSelected = item.favorite
	}

	private func center(location: CLLocationCoordinate2D) {
		mapView.setCenter(location, animated: true)
		let span = MKCoordinateSpan(latitudeDelta: Config.latitudeDelta, longitudeDelta: Config.longitudeDelta)
		let region = MKCoordinateRegion(center: location, span: span)
		mapView.showsUserLocation = true
		mapView.setRegion(region, animated: true)
	}

	// MARK: Routing
	func routing(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
		let request = MKDirections.Request()
		request.source = MKMapItem(placemark: MKPlacemark(coordinate: source, addressDictionary: nil))
		request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
		request.requestsAlternateRoutes = true
		request.transportType = .automobile

		let directions = MKDirections(request: request)

		directions.calculate { [unowned self] response, _ in
			guard let unwrappedResponse = response else { return }

			for route in unwrappedResponse.routes {
				self.mapView.addOverlay(route.polyline)
				self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
			}
		}
	}
	// MARK: Action
	@IBAction func favoriteButtonTouchUpInside(_ sender: Any) {
		favoriteButton.isSelected = !favoriteButton.isSelected
		viewModel?.didUpdateFavorite(isFav: favoriteButton.isSelected)
	}
}

// MARK: MKMapViewDelegate
extension DetailViewController: MKMapViewDelegate {

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKPointAnnotation {
			let identifier = Config.identifier
			var view: PinView

			if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? PinView {
				dequeuedView.annotation = annotation
				view = dequeuedView
			} else {
				view = PinView(annotation: annotation, reuseIdentifier: identifier)
			}
			return view
		}
		return nil
	}

	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

		if let polyline = overlay as? MKPolyline {
			let renderer = MKPolylineRenderer(polyline: polyline)
			renderer.strokeColor = #colorLiteral(red: 0, green: 0.7669754028, blue: 0.3210973144, alpha: 1)
			renderer.lineWidth = Config.lineWidth
			return renderer
		}
		return MKOverlayRenderer()
	}
}

// MARK: Config
extension DetailViewController {

	struct Config {
		static let detailView: String = "DetailView"
		static let identifier: String = "Pin"
		static let originX: CGFloat = 0
		static let originY: CGFloat = 610
		static let hightView: CGFloat = 200
		static let latitudeDelta: CLLocationDegrees = 0.1
		static let longitudeDelta: CLLocationDegrees = 0.1
		static let lineWidth: CGFloat = 6
	}
}
