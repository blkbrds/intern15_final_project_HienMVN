import Foundation
import CoreLocation

final class DetailViewControllerModel {

	// MARK: - Prperties
	private(set) var item = Item()

	// MARK: - Puclic Methods
	func getAddressForDetail() -> String {
		guard let address = item.address else { return "" }
		return address
	}

	func getLocationNameForDetail() -> String {
		guard let locationName = item.name else { return "" }
		return locationName
	}

	func getCityForDetail() -> String {
		guard let city = item.city else { return "" }
		return city
	}

	func getRatingForDetail() -> String {
		guard let rating = item.rating else { return String("7.5") }
		return String(rating)
	}

	func getLikeForDetail() -> String {
		guard let like = item.countOfLike else { return String("21") }
		return String(like) + "Like"
	}

	func getTimeOpen() -> String {
		guard let time = item.closeTime else { return "Open until 7:00 PM" }
		return time
	}

	func getCoordinateForDetail() -> CLLocationCoordinate2D {
		guard let latitude = item.lat, let longitude = item.lng else { return CLLocationCoordinate2D(latitude: 0, longitude: 0) }
		return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
	}

	func getDescriptionForDetail() -> String {
		guard let description = item.description else { return String("Venez vous évader de votre routine quotidienne pour faire une petite pause de beauté pour vos mains ou vos pieds.") }
		return description
	}

	func getURLForDetail() -> String {
		guard let prefix = item.prefix, let sufix = item.suffix else { return "" }
		return prefix + "414x400" + sufix
	}

	// MARK: - Prperties
	let venue: Venue

	// MARK: - init
	init(venue: Venue) {
		self.venue = venue
	}

	// MARK: - Get ID
	func getID() -> String {
		guard let id = venue.id else { return "" }
		return id
	}

	// MARK: - Public Methods
	func getItems(with IDLocation: String, completion: @escaping APICompletion) {
		Api.Item.getItem(id: IDLocation) { [weak self] (result) in
			guard let this = self else { return }
			DispatchQueue.main.async {
				switch result {
				case .failure(let error):
					completion(.failure(error))
				case .success(let data):
					this.item = data
					completion(.success)
				}
			}
		}
	}
}
