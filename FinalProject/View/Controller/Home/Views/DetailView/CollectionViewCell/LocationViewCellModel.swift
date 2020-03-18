import Foundation
import UIKit

class LocationViewCellModel {
	var locationName: String
	var address: String
	var locationImageURL: String

	init(locationName: String = "", locationImageURL: String = "", address: String = "") {
		self.locationName = locationName
		self.locationImageURL = locationImageURL
		self.address = address
	}
}
