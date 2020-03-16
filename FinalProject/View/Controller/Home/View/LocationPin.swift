import Foundation
import MapKit

final class LocationPin: NSObject, MKAnnotation {

	// MARK: - Properties
	let locationName: String
	let coordinate: CLLocationCoordinate2D

	// MARK: - Init
	init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
		self.locationName = locationName
		self.coordinate = coordinate
		super.init()

	}
	var subtitle: String? {
		return locationName

	}
}
