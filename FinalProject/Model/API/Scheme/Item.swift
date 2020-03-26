import ObjectMapper

final class Item: Mappable {

	var id: String?
	var name: String?
	var address: String?
	var city: String?
	var lat: Double?
	var lng: Double?
	var countOfLike: Int?
	var description: String?
	var closeTime: String?
	var prefix: String?
	var suffix: String?
	var groups: JSArray?
	var rating: Int?

	init() { }
	required init?(map: Map) { }

	func mapping(map: Map) {
		id <- map["id"]
		name <- map["name"]
		address <- map["location.address"]
		lat <- map["location.lat"]
		lng <- map["location.lng"]
		city <- map["location.city"]
		countOfLike <- map["like.count"]
		description <- map["description"]
		closeTime <- map["hours.status"]
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
