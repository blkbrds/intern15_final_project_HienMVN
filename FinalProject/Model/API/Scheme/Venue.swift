import Foundation
import CoreLocation

final class Venue {
	var location: CLLocationCoordinate2D
	var country: String
	init(json: JSON) {
		let lat = json["lat"] as? Double
		let lng = json["lng"] as? Double
		self.location = CLLocationCoordinate2D(latitude: lat ?? 0, longitude: lng ?? 0)
		self.country = (json["country"] as? String ?? "")
	}
}
