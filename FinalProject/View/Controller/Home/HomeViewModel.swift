import Foundation
import CoreLocation
import RealmSwift

final class HomeViewModel {

	// MARK: - Prperties
	private let limitVenue: Int = 5
	var selectedVenue: VenueHome?

	// MARK: - Public Method
	func getVenues(currentLocation: CLLocationCoordinate2D, query: String, completion: @escaping APICompletion) {
		Api.VenueHome.getHomeData(lat: currentLocation.latitude, long: currentLocation.longitude, limit: limitVenue, query: query) { [weak self] (result) in
			guard self != nil else { return }
			switch result {
			case .failure(let error):
				completion(.failure(error))
			case .success(let venueResult):
				ObjectManager.share.venueHomes = venueResult.venues
				completion(.success)
			}
		}
	}

	func getDetail(id: String, completion: @escaping APICompletion) {
		Api.VenueDetail.getVenueDetail(id: id) { [weak self] (result) in
			guard self != nil else { return }
			switch result {
			case .failure(let error):
				completion(.failure(error))
			case .success(let data):
				ObjectManager.share.venueDetails.append(data)
				completion(.success)
			}
		}
	}

	func getVenue(at location: CLLocationCoordinate2D) -> VenueHome? {
		return ObjectManager.share.venueHomes.filter({
			location.latitude == $0.location?.latitude && location.longitude == $0.location?.longitude
		})[0]
	}

	func detailViewControllerModel() -> DetailViewControllerModel? {
		let venueDetail = ObjectManager.share.venueDetails.first { $0.id == selectedVenue?.id }
		guard let venue = venueDetail else { return nil }
		return DetailViewControllerModel(venue: venue, id: self.selectedVenue?.id)
	}
}
