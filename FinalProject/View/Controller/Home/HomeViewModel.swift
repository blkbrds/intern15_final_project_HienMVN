import Foundation
import CoreLocation
import RealmSwift

final class HomeViewModel {

	// MARK: - Prperties
	private let limitVenue: Int = 5

	// MARK: - Public Methods
	func getVenues(currentLocation: CLLocationCoordinate2D, completion: @escaping APICompletion) {
		Api.VenueHome.getHomeData(lat: currentLocation.latitude, long: currentLocation.longitude, limit: limitVenue) { [weak self] (result) in
			guard self != nil else { return }
			switch result {
			case .failure(let error):
				completion(.failure(error))
			case .success(let venueResult):
				ObjectManager.share.venues = venueResult.venues
				completion(.success)
			}
		}
	}

	func getVenue(at location: CLLocationCoordinate2D) -> VenueHome? {
		return ObjectManager.share.venues.filter({
			location.latitude == $0.location?.latitude && location.longitude == $0.location?.longitude
		})[0]
	}

	var selectedVenue: VenueHome?

	func detailViewControllerModel() -> DetailViewControllerModel? {
		let venueDetail = ObjectManager.share.venueDetails.first { $0.id == selectedVenue?.id }
		guard let venue = venueDetail else { return nil }
		return DetailViewControllerModel(venue: venue, id: self.selectedVenue?.id)
	}

	func getDetail(at index: Int, completion: @escaping APICompletion) {
		if index >= ObjectManager.share.venues.count { return }
		var tempIndex: Int = index
		guard let id: String = ObjectManager.share.venues[index].id else {
			completion(.failure(Api.Error.emptyData))
			return
		}
		Api.VenueDetail.getItem(id: id) { [weak self] (result) in
			guard let this = self else { return }
			tempIndex += 1
			switch result {
			case .failure(let error):
				completion(.failure(error))
			case .success(let data):
				ObjectManager.share.venueDetails.append(data)
				completion(.success)
				print(index, "OK")
				this.getDetail(at: tempIndex, completion: completion)
			}
		}
	}
}
