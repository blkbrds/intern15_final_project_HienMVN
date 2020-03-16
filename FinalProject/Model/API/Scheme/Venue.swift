import Foundation
import CoreLocation

final class Venue {
	var location: CLLocationCoordinate2D?
	var country: String?
	var name: String?
	init(json: JSON) {
		if let location = json["location"] as? [String: Any], let lat = location["lat"] as? Double, let lng = location["lng"] as? Double {
			self.location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
		}
		self.country = json["country"] as? String
		self.name = json["name"] as? String
	}
}
