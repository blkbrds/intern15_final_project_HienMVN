import UIKit
import MapKit

final class HomeViewController: ViewController {

	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var currentLocationButton: CustomButton!

	var viewmodel = HomeViewModel()

	override func viewDidLoad() {
		mapView.delegate = self
		super.viewDidLoad()
		let danangLocation = CLLocation(latitude: 16.0077, longitude: 108.227)
		let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
		let region = MKCoordinateRegion(center: danangLocation.coordinate, span: span)
		mapView.region = region
	}

	override func setupUI() {
		title = "Map"
		loadAPI()
	}

	private func loadAPI () {
		viewmodel.getLocation { (done, msg) in
			if done {
				print("hoan thanh")
			} else {
				print("gg")
			}
		}
	}
	private func center(location: CLLocation) {
		mapView.setCenter(location.coordinate, animated: true)
		let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
		let region = MKCoordinateRegion(center: location.coordinate, span: span)
		mapView.setRegion(region, animated: true)
		mapView.showsUserLocation = true
	}
	private func zoom(location: CLLocation, span: Float) {
		let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(span), longitudeDelta: CLLocationDegrees(span))
		let region = MKCoordinateRegion(center: location.coordinate, span: span)
		mapView.setRegion(region, animated: true)
	}

	@IBAction func moveCurrentLocation(_ sender: Any) {
		LocationManager.shared().getCurrentLocation { (location) in
			self.center(location: location)
		}
	}
}
extension HomeViewController: MKMapViewDelegate {
}
