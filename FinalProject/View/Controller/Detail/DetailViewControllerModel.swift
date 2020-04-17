import Foundation
import CoreLocation
import RealmSwift

final class DetailViewControllerModel {

	// MARK: - Prperties
	var venueDetail: VenueDetail?
	private let limitVenue: Int = 10
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

	func deleteFavorite() {
		guard let idVenueDetail = venueDetail?.id else { return }
		RealmManager.shared.deleteOjbectInRealm(at: idVenueDetail)
	}

	// MARK: - Get Coordinate of pin
	func getLocationCoordinate() -> CLLocationCoordinate2D {
		guard let venueDetail = venueDetail else { return CLLocationCoordinate2D(latitude: 0, longitude: 0) }
		return CLLocationCoordinate2D(latitude: venueDetail.lat, longitude: venueDetail.lng)
	}

	// MARK: - Get API for VenuesSimilar
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

// MARK: - Get API for VenuesDetail
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

	// MARK: - Push venueID and venuedetail  for detail
	func detailViewControllerModel() -> DetailViewControllerModel {
		let venueDetail = ObjectManager.share.venueDetails.first { $0.id == selectedVenue?.id }
		if venueDetail != nil {
			return DetailViewControllerModel(venue: venueDetail, id: nil)
		} else {
			return DetailViewControllerModel(venue: nil, id: selectedVenue?.id)
		}
	}
	// MARK: -
	func getDetailTableViewModel(at indexPath: IndexPath) -> DetailTableViewModel? {
		guard indexPath.row < venues.count else { return nil }
		return DetailTableViewModel(imageURL: venues[indexPath.row].prefix, locationName: venues[indexPath.row].name, address: venues[indexPath.row].address, city: venues[indexPath.row].country)
	}
}
