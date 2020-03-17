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
		viewmodel.delegate = self
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
		guard let annotation = annotation as? MKPointAnnotation else { return nil }
		let identifier = "pin"
		var view: MKPinAnnotationView

		if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
			dequeuedView.annotation = annotation
			view = dequeuedView

		} else {
			view = PinView(annotation: annotation, reuseIdentifier: identifier)
			let button = UIButton(type: .detailDisclosure)
			button.addTarget(self, action: #selector(selectPinView(_:)), for: .touchDown)
			view.rightCalloutAccessoryView = button
			view.leftCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "icons8-location-off-30 (3)"))
			view.canShowCallout = true
		}
		return view
	}

	@objc func selectPinView(_ sender: UIButton?) {

	}

	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		viewmodel.getVenues(currentLocation: mapView.userLocation.coordinate)
		center(location: mapView.userLocation.coordinate)
	}
}

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {

	func showError(stringError: String) {
		print(stringError)
	}

	func loadVenues(venues: [Venue]) {
		DispatchQueue.main.async {
			self.mapView.removeAnnotations(self.mapView.annotations)
			venues.forEach { (venue) in
				if let location = venue.location {
					let annotation = MKPointAnnotation()
					annotation.coordinate = location
					annotation.title = venue.name
					self.mapView.addAnnotation(annotation)
				}
			}
		}
	}
}
