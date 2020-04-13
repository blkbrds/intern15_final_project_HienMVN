import Foundation
import UIKit

final class LocationViewCellModel {

	// MARK: - Properties
	var locationName: String?
	var country: String?
	var locationImageURL: String?
	var suffix: String?
	var prefix: String?

	// MARK: - Init
	init(locationName: String?, locationImageURL: String?, country: String?, suffix: String?, prefix: String?) {
		self.locationName = locationName
		self.locationImageURL = locationImageURL
		self.country = country
		self.suffix = suffix
		self.prefix = prefix
	}
}
