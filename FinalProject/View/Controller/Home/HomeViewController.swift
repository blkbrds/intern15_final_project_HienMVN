import UIKit
import MapKit

final class HomeViewController: ViewController {

	// MARK: - Outlets
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var currentLocationButton: CustomButton!
	private var detailView: DetailView!
	// MARK: - Properties
	var viewModel = HomeViewModel()

	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.delegate = self
		mapView.showsUserLocation = true
		configDetailView()
		center(location: mapView.userLocation.coordinate)
	}

	// MARK: - Override
	override func setupUI() {
		title = "Home"
	}

	// MARK: - Private Methods
	private func center(location: CLLocationCoordinate2D) {
		mapView.setCenter(location, animated: true)
		let span = MKCoordinateSpan(latitudeDelta: Config.latitudeDelta, longitudeDelta: Config.longitudeDelta)
		let region = MKCoordinateRegion(center: location, span: span)
		mapView.setRegion(region, animated: true)
	}

	private func configDetailView() {
		if detailView == nil {
			guard let userView = Bundle.main.loadNibNamed(Config.detailView, owner: self, options: nil)?.first as? DetailView else { return }
			userView.frame = CGRect(x: Config.originX, y: Config.originY, width: view.bounds.width, height: Config.hightView)
			detailView = userView
			view.addSubview(detailView)
		}
	}

	// MARK: - Action
	@IBAction func moveCurrentLocation(_ sender: Any) {
		center(location: self.mapView.userLocation.coordinate)
	}
}

// MARK: - MKMapViewDelegate
extension HomeViewController: MKMapViewDelegate {

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKPointAnnotation {
			let identifier = Config.identifier
			var view: PinView

			if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? PinView {
				dequeuedView.annotation = annotation
				view = dequeuedView
			} else {
				view = PinView(annotation: annotation, reuseIdentifier: identifier)
				let button = UIButton(type: .detailDisclosure)
				button.addTarget(self, action: #selector(selectPinView(_:)), for: .touchDown)
				view.rightCalloutAccessoryView = button
				view.leftCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "pin"))
				view.canShowCallout = true
			}
			return view
		}
		return nil
	}

	@objc private func selectPinView(_ sender: UIButton?) {
		let detailVC = DetailViewController()
		detailVC.viewModel = viewModel.detailViewControllerModel()
		navigationController?.pushViewController(detailVC, animated: true)
	}

	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		getVenue(currentLocation: mapView.userLocation.coordinate)
		center(location: mapView.userLocation.coordinate)
	}

	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		let selectedAnnotation = view.annotation as? MKPointAnnotation
		guard let coordinate = selectedAnnotation?.coordinate else { return }
		center(location: coordinate)
		if let venue = viewModel.getVenue(at: coordinate) {
			viewModel.selectedVenue = venue
			detailView.scrollCollectionView(to: venue)
		}
	}

	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
	//	let center = mapView.centerCoordinate
	}
}

// MARK: Load Api
extension HomeViewController {
	func getVenue(currentLocation: CLLocationCoordinate2D) {
		viewModel.getVenues(currentLocation: currentLocation) { [weak self] (result) in
			guard let this = self else { return }
			switch result {
			case .success:
//				self.mapView.removeAnnotations(self.mapView.annotations)
				this.viewModel.venues.forEach { (venue) in
					if let location = venue.location {
						let annotation = MKPointAnnotation()
						annotation.coordinate = location
						annotation.title = venue.name
						this.mapView.addAnnotation(annotation)
					}
				}
				this.detailView.viewModel = DetailViewModel(this.viewModel.venues)
			case .failure(let error):
				this.alert(msg: error.localizedDescription, handler: nil)
			}
		}
	}
}

// MARK: Config
extension HomeViewController {
	struct Config {
		static let detailView: String = "DetailView"
		static let identifier: String = "Pin"
		static let originX: CGFloat = 0
		static let originY: CGFloat = 610
		static let hightView: CGFloat = 200
		static let latitudeDelta: CLLocationDegrees = 0.005
		static let longitudeDelta: CLLocationDegrees = 0.005

	}
}
