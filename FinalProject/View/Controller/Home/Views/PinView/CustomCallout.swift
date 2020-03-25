import Foundation
import MapKit

class CustomCallout: NSObject, MKAnnotation {
	var id: String?
	let locationName: String
	var address: String
	let coordinate: CLLocationCoordinate2D

	init(id: String, locationName: String, address: String, coordinate: CLLocationCoordinate2D) {
		self.id = id
		self.locationName = locationName
		self.address = address
		self.coordinate = coordinate

		super.init()
	}

	var subtitle: String? {
		return locationName
	}
}
