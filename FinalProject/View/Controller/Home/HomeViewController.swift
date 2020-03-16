import UIKit
import MapKit

final class HomeViewController: ViewController {

	// MARK: - Outlet
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var currentLocationButton: CustomButton!

	// MARK: - Viewmodel
	var viewmodel = HomeViewModel()

	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.delegate = self
		viewmodel.delegate = self
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
		if annotation is MKPointAnnotation {
			let identifier = "pin"
			var view: MKPinAnnotationView

			if let dequeuwdView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
				dequeuwdView.annotation = annotation
				view = dequeuwdView

			} else {
				view = PinView(annotation: annotation, reuseIdentifier: identifier)
				view.animatesDrop = true
				view.pinTintColor = #colorLiteral(red: 0, green: 0.9799041152, blue: 0.4211293161, alpha: 1)
				view.canShowCallout = true
			}
			return view
		} else if let annotation = annotation as? LocationPin {
			let identifier = "mypin"
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
		} else {
			return nil
		}
	}

	@objc func selectPinView(_ sender: UIButton?) {
		print("select button detail")
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
