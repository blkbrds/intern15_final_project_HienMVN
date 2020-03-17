import Foundation
import CoreLocation

final class Venue {

	var location: CLLocationCoordinate2D?
	var country: String?
	var name: String?
	var id: String?

	init(json: JSON) {
		if let location = json["location"] as? [String: Any], let lat = location["lat"] as? Double, let lng = location["lng"] as? Double {
			self.location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
		}
		country = json["country"] as? String
		name = json["name"] as? String
		id = json["id"] as? String
	}
}
