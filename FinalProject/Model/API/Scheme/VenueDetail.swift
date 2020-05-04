import ObjectMapper
import RealmSwift

final class VenueDetail: Object, Mappable {

	@objc dynamic var id: String?
	@objc dynamic var name: String?
	@objc dynamic var address: String?
	@objc dynamic var city: String?
	@objc dynamic var lat: Double = 0
	@objc dynamic var lng: Double = 0
	@objc dynamic var countOfLike: Int = 3
	@objc dynamic var descriptionText: String = "..."
	@objc dynamic var openTime: String = "Closed until 2:00 PM"
	@objc dynamic var prefix: String?
	@objc dynamic var suffix: String?
	var groups: JSArray?
	@objc dynamic var rating: Int = 0
	@objc dynamic var favorite: Bool = false

	required convenience init?(map: Map) {
		self.init()
	}

	override static func primaryKey() -> String? {
		return "id"
	}

	func mapping(map: Map) {
		id <- map["id"]
		name <- map["name"]
		address <- map["location.address"]
		lat <- map["location.lat"]
		lng <- map["location.lng"]
		city <- map["location.city"]
		countOfLike <- map["like.count"]
		descriptionText <- map["description"]
		openTime <- map["hours.status"]
		groups <- map["photos.groups"]
		rating <- map["rating"]
		guard let groups = groups else { return }
		for index in groups {
			guard let items = index["items"] as? JSArray else { return }
			for index in items {
				guard let prefix = index["prefix"] as? String,
					let suffix = index["suffix"] as? String else { return }
				self.prefix = prefix
				self.suffix = suffix
			}
		}
	}

}
