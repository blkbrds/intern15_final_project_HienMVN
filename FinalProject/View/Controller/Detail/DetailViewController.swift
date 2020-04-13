import UIKit
import MapKit
import SDWebImage
import SVProgressHUD

final class DetailViewController: ViewController {

	// MARK: Outlet
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var favoriteButton: UIButton!
	@IBOutlet weak var timeOpenLabel: UILabel!
	@IBOutlet weak var locationImageView: UIImageView!
	@IBOutlet weak var discriptionLabel: UILabel!
	@IBOutlet weak var likeLabel: UILabel!
	@IBOutlet weak var ratingLabel: UILabel!
	@IBOutlet weak var locationNameLabel: UILabel!
	@IBOutlet weak var addressLabel: UILabel!

	// MARK: Properties
	var viewModel: DetailViewControllerModel? {
		didSet {
//			if viewModel?.venueDetail == nil {
//				viewModel?.getVenuesDetail(completion: { [weak self] (result) in
//					guard let this = self else { return }
//					switch result {
//					case .failure(let error):
//						self?.alert(msg: error.localizedDescription, handler: nil)
//					case .success:
//						this.getAPIForDetail()
//						DispatchQueue.main.async {
//							guard let location = this.viewModel?.getLocationCoordinate() else { return }
//							this.center(location: location)
//							this.setupUI()
//						}
//
//					}
//				})
//			}
//			getAPIForDetail()
		}
	}

	// MARK: Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = #colorLiteral(red: 0.2901675105, green: 0.29021433, blue: 0.2901572585, alpha: 1)
		mapView.delegate = self
		mapView.showsUserLocation = true
		guard let lat = viewModel?.venueDetail?.lat, let long = viewModel?.venueDetail?.lng else { return }
		let venueCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
		guard let location = viewModel?.getLocationCoordinate() else { return }
		addPin(coordinate: venueCoordinate)
		center(location: location)
//		routing(source: venueCoordinate, destination: location)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		guard let realm = RealmManager.shared.realm else { return }
		guard let locationName = locationNameLabel.text else { return }
		if realm.objects(VenueDetail.self).filter(NSPredicate(format: "name = %@", locationName)).isEmpty {
			favoriteButton.isSelected = false
		} else {
			favoriteButton.isSelected = true
		}
		makeNavigationBarTransparent()
	}
	//private func configMap

	private func makeNavigationBarTransparent(isTranslucent: Bool = true) {
		let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-back-52"), style: .plain, target: self, action: #selector(backTouchUpInside))
		navigationItem.leftBarButtonItem = backButton
		backButton.tintColor = #colorLiteral(red: 0.8098723292, green: 0.02284341678, blue: 0.3325383663, alpha: 1)
		if let navBar = self.navigationController?.navigationBar {
			let blankImage = UIImage()
			navBar.setBackgroundImage(blankImage, for: .default)
			navBar.shadowImage = blankImage
			navBar.isTranslucent = isTranslucent
		}
	}

	// MARK: Action Back To Home_VC
	@objc func backTouchUpInside() {
		navigationController?.popViewController(animated: true)
	}

	// MARK: Private Methods
	override func setupUI() {
		guard let item = viewModel?.venueDetail else { return }
		locationNameLabel.text = item.name
		addressLabel.text = item.address
		cityLabel.text = item.city
		ratingLabel.text = String(item.rating)
		likeLabel.text = String(item.countOfLike)
		discriptionLabel.text = item.descriptionText
		if let prefix = item.prefix, let sufix = item.suffix {
			let url = prefix + Config.sizeOfImage + sufix
			locationImageView.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "dsad"))
		}
		timeOpenLabel.text = item.openTime
		favoriteButton.isSelected = item.favorite
	}



	private func center(location: CLLocationCoordinate2D) {
		mapView.setCenter(location, animated: true)
		let span = MKCoordinateSpan(latitudeDelta: Config.latitudeDelta, longitudeDelta: Config.longitudeDelta)
		let region = MKCoordinateRegion(center: location, span: span)
		mapView.setRegion(region, animated: true)
	}
	private func addPin(coordinate: CLLocationCoordinate2D) {
		let annotation = MKPointAnnotation()
		annotation.coordinate = coordinate
		mapView.addAnnotation(annotation)
	}

	private func routing(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
		let request = MKDirections.Request()
		request.source = MKMapItem(placemark: MKPlacemark(coordinate: source, addressDictionary: nil))
		request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
		request.requestsAlternateRoutes = true
		request.transportType = .automobile

		let directions = MKDirections(request: request)

		directions.calculate { [unowned self] (response, error) in
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
		viewModel?.didUpdateFavorite()
	}
}

// MARK: Get API
//extension DetailViewController {
//	func getAPIForDetail() {
//		guard let locationCoordinate = viewModel?.getLocationCoordinate() else { return }
//		viewModel?.getVenues(currentLocation: locationCoordinate) { [weak self] (result) in
//			guard let this = self else { return }
//			switch result {
//			case .success:
//				this.viewModel?.venues.forEach({ (venue) in
//					if let location = venue.location {
//						let annotation = MKPointAnnotation()
//						annotation.coordinate = location
//						annotation.title = venue.name
//						this.mapView.addAnnotation(annotation)
//					}
//				})
//			case .failure(let error):
//				this.alert(msg: error.localizedDescription, handler: nil)
//			}
//		}
//	}
//}

// MARK: MKMapViewDelegate
extension DetailViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKPointAnnotation {
			let identifier = Config.identifier
			var view: MKPinAnnotationView

			if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
				dequeuedView.annotation = annotation
				view = dequeuedView
			} else {
				view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
			}
			return view
		}
		return nil
	}
	
	//MARK: - Renderer
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

		if let polyline = overlay as? MKPolyline {
			let renderer = MKPolylineRenderer(polyline: polyline)
			renderer.strokeColor = UIColor.blue
			renderer.lineWidth = 3
			return renderer

		} else if let circle = overlay as? MKCircle {
			let circleRenderer = MKCircleRenderer(circle: circle)
			circleRenderer.fillColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
			circleRenderer.strokeColor = .blue
			circleRenderer.lineWidth = 1
			circleRenderer.lineDashPhase = 10
			return circleRenderer

		} else {
			return MKOverlayRenderer()
		}

	}


//	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//		let selectedAnnotation = view.annotation as? MKPointAnnotation
//		guard let coordinate = selectedAnnotation?.coordinate else { return }
//		guard let viewModel = viewModel else { return }
//		if let venue = viewModel.getVenue(at: coordinate) {
//			viewModel.selectedVenue = venue
//		}
//	}
//
//	@objc private func selectPinView(_ sender: UIButton?) {
//		let detailVC = DetailViewController()
//		detailVC.viewModel = viewModel?.detailViewControllerModel()
//		navigationController?.pushViewController(detailVC, animated: true)
//	}
}

// MARK: Config
extension DetailViewController {
	struct Config {
		static let detailView: String = "DetailView"
		static let identifier: String = "Pin"
		static let originX: CGFloat = 0
		static let originY: CGFloat = 610
		static let hightView: CGFloat = 200
		static let latitudeDelta: CLLocationDegrees = 0.005
		static let longitudeDelta: CLLocationDegrees = 0.005
		static let lineWidth: CGFloat = 6
		static let sizeOfImage: String = "414x414"
	}
}
