import Foundation

class DetailTableViewModel {

	var locationName: String?
	var imageURL: String?
	var address: String?
	var city: String?

	init(imageURL: String?, locationName: String?, address: String?, city: String?) {
		self.locationName = locationName
		self.address = address
		self.city = city
		self.imageURL = imageURL
	}
}
