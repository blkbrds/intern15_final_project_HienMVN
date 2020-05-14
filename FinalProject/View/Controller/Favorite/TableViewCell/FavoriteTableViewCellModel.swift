import Foundation

final class FavoriteTableViewCellModel {

	// MARK: - Properties
	var locationName: String?
	var address: String?
	var suffix: String?
	var prefix: String?
	var timeOpen: String?
	var like: Int?
	var rating: Int?

	// MARK: - Init
	init(locationName: String?, address: String?, timeOpen: String?, like: Int?, rating: Int?, suffix: String?, prefix: String?) {
		self.locationName = locationName
		self.address = address
		self.timeOpen = timeOpen
		self.rating = rating
		self.like = like
		self.suffix = suffix
		self.prefix = prefix
	}

}
