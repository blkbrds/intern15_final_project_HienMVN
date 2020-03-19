import Foundation
import CoreLocation

final class Venue {

	var location: CLLocationCoordinate2D?
	var country: String?
	var name: String?
	var id: String?
	var prefix: String?

	init(json: JSON) {
		if let location = json["location"] as? [String: Any], let lat = location["lat"] as? Double, let lng = location["lng"] as? Double, let country = location["country"] as? String {
			self.location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
			self.country = country
		}
		if let categories = json["categories"] as? JSArray {
			for item in categories {
				guard let icon = item["icon"] as? JSObject else { return }
				prefix = (icon["prefix"] as? String)
			}
		}
		name = json["name"] as? String
		id = json["id"] as? String
	}
}

extension Venue: Equatable {
	static func == (lhs: Venue, rhs: Venue) -> Bool {
		return lhs.id == rhs.id
	}
}
