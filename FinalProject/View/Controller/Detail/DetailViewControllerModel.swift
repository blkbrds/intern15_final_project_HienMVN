import Foundation
import CoreLocation
import RealmSwift

final class DetailViewControllerModel {

	// MARK: - Prperties
	var venueDetail: VenueDetail?
	private let limitVenue: Int = 5
	private(set) var venues: [VenueHome] = []
	var selectedVenue: VenueHome?
	var id: String?

	// MARK: - Init
	init(venue: VenueDetail?, id: String?) {
		self.venueDetail = venue
		self.id = id
	}

	// MARK: - Update Favorite Realm
	func didUpdateFavorite() {
		guard let venueDetail = venueDetail else { return }
		RealmManager.shared.addRealm(data: venueDetail)
	}

	// MARK: - Get Coordinate of pin
	func getLocationCoordinate() -> CLLocationCoordinate2D {
		guard let venueDetail = venueDetail else { return CLLocationCoordinate2D(latitude: 0, longitude: 0) }
		return CLLocationCoordinate2D(latitude: venueDetail.lat, longitude: venueDetail.lng)
	}

	// MARK: - Get API
	func getVenues(currentLocation: CLLocationCoordinate2D, completion: @escaping APICompletion) {
		guard let lat = venueDetail?.lat,
			let lng = venueDetail?.lng else {
				completion(.failure(Api.Error.emptyData))
				return
		}
		Api.VenueHome.getHomeData(lat: lat, long: lng, limit: limitVenue, query: "") { [weak self] (result) in
			guard let this = self else { return }
			switch result {
			case .failure(let error):
				completion(.failure(error))
			case .success(let venueResult):
				this.venues = venueResult.venues
				completion(.success)
			}
		}
	}

	func getVenuesDetail(completion: @escaping APICompletion) {
		guard let id = id else {
			completion(.failure(Api.Error.emptyData))
			return
		}
		Api.VenueDetail.getVenueDetail(id: id) { [weak self] (result) in
			guard let this = self else { return }
			switch result {
			case.failure(let error):
				completion(.failure(error))
			case.success(let data):
				this.venueDetail = data
				completion(.success)
			}
		}
	}

	// MARK: - Get venue đid select
	func getVenue(at location: CLLocationCoordinate2D) -> VenueHome? {
		return venues.filter({
			location.latitude == $0.location?.latitude && location.longitude == $0.location?.longitude
		})[0]
	}

	// MARK: - Push venueID and venuedetail  for detail
	func detailViewControllerModel() -> DetailViewControllerModel {
		let venueDetail = ObjectManager.share.venueDetails.first { $0.id == selectedVenue?.id }
		if venueDetail != nil {
			return DetailViewControllerModel(venue: venueDetail, id: nil)
		} else {
			return DetailViewControllerModel(venue: nil, id: selectedVenue?.id)
		}
	}
}
