import Foundation
import CoreLocation

final class VenueHome {

	var location: CLLocationCoordinate2D?
	var country: String?
	var name: String?
	var id: String?
	var prefix: String?
	var favorite: Bool = false

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

extension VenueHome: Equatable {
	static func == (lhs: VenueHome, rhs: VenueHome) -> Bool {
		return lhs.id == rhs.id
	}
}
