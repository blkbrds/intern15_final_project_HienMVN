import UIKit
import MapKit
import SDWebImage

final class DetailViewController: ViewController {

	// MARK: Outlet
	@IBOutlet weak private var ratingLabel: UILabel!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var favoriteButton: UIButton!
	@IBOutlet weak private var locationNameLabel: UILabel!
	@IBOutlet weak private var locationImageView: UIImageView!
	@IBOutlet weak private var addressLabel: UILabel!
	@IBOutlet weak private var mapView: MKMapView!
	@IBOutlet weak private var descriptionTextView: UITextView!
	@IBOutlet weak private var textViewCH: NSLayoutConstraint!
	@IBOutlet weak private var timeOpenLabel: UILabel!
	@IBOutlet weak private var dislikeLabel: UILabel!
	@IBOutlet weak private var loveLabel: UILabel!
	@IBOutlet weak private var likeLabel: UILabel!
	@IBOutlet weak private var cityLabel: UILabel!

	// MARK: Properties
	var viewModel: DetailViewControllerModel?

	// MARK: Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.delegate = self
		center(location: mapView.userLocation.coordinate)
		scrollView.isHidden = true
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		getAPIForDetail()
	}

	// MARK: Private Methods
	private func configTextView() {
		textViewCH.constant = self.descriptionTextView.contentSize.height
	}

	private func updateUI() {
		guard let item = viewModel?.venueDetail else { return }
		locationNameLabel.text = item.name
		addressLabel.text = item.address
		cityLabel.text = item.city
		ratingLabel.text = String(item.rating)
		likeLabel.text = String(item.countOfLike) + "Like"
		descriptionTextView.text = item.descriptionText
		if let prefix = item.prefix, let sufix = item.suffix {
			let url = prefix + "414x400" + sufix
			locationImageView.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "paris"))
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
// MARK: Get API
extension DetailViewController {

	func getAPIForDetail() {
		viewModel?.getItems {[weak self] (result) in
			guard let this = self else { return }
			switch result {
			case .success:
				this.updateUI()
				this.configTextView()
				if let lat = this.viewModel?.venueDetail?.lat, let lon = this.viewModel?.venueDetail?.lng {
					let annotation = MKPointAnnotation()
					let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
					annotation.coordinate = location
					this.mapView.addAnnotation(annotation)
					this.routing(source: this.mapView.userLocation.coordinate, destination: location)
					this.scrollView.isHidden = false
				}
			case .failure(let error):
				this.alert(msg: error.localizedDescription, handler: nil)
			}
		}
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
