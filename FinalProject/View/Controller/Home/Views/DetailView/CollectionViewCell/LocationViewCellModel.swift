import Foundation
import UIKit

final class LocationViewCellModel {

	// MARK: - Properties
	var locationName: String
	var country: String
	var locationImageURL: String?
	var imageDetail: String?

	// MARK: - Init
	init(locationName: String = "", locationImageURL: String, country: String = "", imageDetail: String = "") {
		self.locationName = locationName
		self.locationImageURL = locationImageURL
		self.country = country
		self.imageDetail = imageDetail
	}
}
