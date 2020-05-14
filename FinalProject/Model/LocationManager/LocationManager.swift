import Foundation
import CoreLocation

typealias LocationCompletion = (CLLocation) -> Void

protocol LocationManagerDelegate: class {
	func locationManager(locationManager: LocationManager, didUpdateCurrentLocation currentLocation: CLLocation)
}

final class LocationManager: NSObject {

	// MARK: - Singleton
	static let shared: LocationManager = {
		return LocationManager()
	}()

	// MARK: - Properties
	private let locationManager = CLLocationManager()
	private var currentLocation: CLLocation?
	private var currentCompletion: LocationCompletion?
	private var locationCompletion: LocationCompletion?
	private var isUpdatingLocation = false

	// Delegate
	weak var locationHomeDelegate: LocationManagerDelegate?
	weak var locationDetailDelegate: LocationManagerDelegate?

	// MARK: - init
	override init() {
		super.init()
		configLocationManager()
	}

	// MARK: - Public Methods
	func request() {
		let status = CLLocationManager.authorizationStatus()
		if status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled() {
			return
		}
		if status == .notDetermined {
			locationManager.requestWhenInUseAuthorization()
			return
		}

		locationManager.requestLocation()
		locationManager.startUpdatingLocation()
	}

	func getCurrentLocation(completion: @escaping LocationCompletion) {
		currentCompletion = completion
		locationManager.requestLocation()
	}

	// MARK: - Private Methods
	private func getCurrentLocation() -> CLLocation? {
		return currentLocation
	}

	func startUpdating(completion: @escaping LocationCompletion) {
		locationCompletion = completion
		isUpdatingLocation = true
		locationManager.startUpdatingLocation()
	}

	func stopUpdating() {
		locationManager.stopUpdatingLocation()
		isUpdatingLocation = false
	}

	func configLocationManager() {
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.distanceFilter = 10
	}
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {

	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		print("location manager authorization status changed")

		switch status {
		case .authorizedAlways:
			print("user allow app to get location data when app is active or in background")
			manager.requestLocation()

		case .authorizedWhenInUse:
			print("user allow app to get location data only when app is active")
			manager.requestLocation()

		case .denied:
			print("user tap 'disallow' on the permission dialog, cant get location data")

		case .restricted:
			print("parental control setting disallow location data")

		case .notDetermined:
			print("the location permission dialog haven't shown before, user haven't tap allow/disallow")

		default:
			print("default")
		}
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			self.currentLocation = location

			if let current = currentCompletion {
				current(location)
			}
			locationHomeDelegate?.locationManager(locationManager: self, didUpdateCurrentLocation: location)
			locationDetailDelegate?.locationManager(locationManager: self, didUpdateCurrentLocation: location)

			if isUpdatingLocation, let updating = locationCompletion {
				updating(location)
			}
		}
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Error: \(error.localizedDescription)")
	}
}
