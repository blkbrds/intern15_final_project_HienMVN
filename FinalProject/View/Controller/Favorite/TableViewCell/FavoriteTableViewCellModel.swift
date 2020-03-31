import Foundation

final class FavoriteTableViewCellModel {

	// MARK: - Properties
	var locationName: String
	var address: String
	var suffix: String
	var prefix: String

	// MARK: - Init
	init(locationName: String, address: String, suffix: String, prefix: String) {
		self.locationName = locationName
		self.address = address
		self.suffix = suffix
		self.prefix = prefix
	}

}
