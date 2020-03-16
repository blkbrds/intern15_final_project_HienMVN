import Foundation
import MapKit

class LocationPin: NSObject, MKAnnotation {
	let locationName: String
	let coordinate: CLLocationCoordinate2D

	init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
		self.locationName = locationName
		self.coordinate = coordinate
		super.init()

	}
	var subtitle: String? {
		return locationName

	}
}
