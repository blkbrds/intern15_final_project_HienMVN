import UIKit
import MapKit

final class HomeViewController: ViewController {

	// MARK: - Outlets
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var currentLocationButton: CustomButton!

	// MARK: - Properties
	var viewmodel = HomeViewModel()

	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.delegate = self
		mapView.showsUserLocation = true
		center(location: mapView.userLocation.coordinate)
	}

	// MARK: - Override
	override func setupUI() {
		title = "Map"
	}

	// MARK: - Private Methods
	private func center(location: CLLocationCoordinate2D) {
		mapView.setCenter(location, animated: true)
		let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
		let region = MKCoordinateRegion(center: location, span: span)
		mapView.setRegion(region, animated: true)
	}

	private func configDetailView() {
		let userView = Bundle.main.loadNibNamed("DetailView", owner: self, options: nil)?.first as? DetailView
		userView?.viewmodel = DetailViewModel(viewmodel.venues)
		userView?.frame = CGRect(x: 0, y: 596, width: view.bounds.width, height: 240)
		guard let userViews = userView else { return }
		view.addSubview(userViews)
	}

	// MARK: - Action
	@IBAction func moveCurrentLocation(_ sender: Any) {
		LocationManager.shared.getCurrentLocation { (location) in
			self.center(location: self.mapView.userLocation.coordinate)
		}
	}
}

// MARK: - MKMapViewDelegate
extension HomeViewController: MKMapViewDelegate {

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKPointAnnotation {
			let identifier = "pin"
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

	@objc func selectPinView(_ sender: UIButton?) {
	}

	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		getVenue(currentLocation: mapView.userLocation.coordinate)
		center(location: mapView.userLocation.coordinate)
	}
}

// MARK: Load Api
extension HomeViewController {
	func getVenue(currentLocation: CLLocationCoordinate2D) {
		viewmodel.getVenues(currentLocation: currentLocation) { [weak self] (result) in
			guard let self = self else { return }
			switch result {
			case .success:
				self.mapView.removeAnnotations(self.mapView.annotations)
				self.viewmodel.venues.forEach { (venue) in
					if let location = venue.location {
						let annotation = MKPointAnnotation()
						annotation.coordinate = location
						annotation.title = venue.name
						self.mapView.addAnnotation(annotation)
						self.configDetailView()
					}
				}
			case .failure(let error):
				self.alert(msg: error.localizedDescription, handler: nil)
			}
		}
	}
}
