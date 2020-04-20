import Foundation
import CoreLocation
import RealmSwift

final class HomeViewModel {

	// MARK: - Prperties
	private(set) var venues: [VenueHome] = []
	private(set) var venueDetail = VenueDetail()
	private let limitVenue: Int = 5

	func addRealm(data: VenueDetail) {
		do {
			let realm = try Realm()
			try realm.write {
				let data = data
				realm.add(data)
			}
		} catch {
			print("Lỗi thêm đối tượng vào Realm")
		}
	}

	func getRealm() -> Results<VenueDetail>? {
		do {
			let realm = try Realm()
			let listVenueDetail: Results<VenueDetail> = { realm.objects(VenueDetail.self) }()
			return listVenueDetail
		} catch {
			print("Lỗi GET đối tượng 🇺🇸")
			return nil
		}
	}

	// MARK: - Public Methods
	func getVenues(currentLocation: CLLocationCoordinate2D, completion: @escaping APICompletion) {
		Api.VenueHome.getHomeData(lat: currentLocation.latitude, long: currentLocation.longitude, limit: limitVenue) { [weak self] (result) in
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

	func getVenuesHome(venueID: String, completion: @escaping APICompletion) {
		if let item = getRealm()?.first(where: { ($0.id == venueID) }) {
			self.venueDetail = item
			completion(.success)
		} else {
			Api.VenueDetail.getItem(id: venueID) { [weak self] (result) in
				guard let this = self else { return }
				switch result {
				case .failure(let error):
					completion(.failure(error))
				case .success(let data):
					this.venueDetail = data
					this.addRealm(data: data)
					completion(.success)
				}
			}
		}
	}

	func getVenue(at location: CLLocationCoordinate2D) -> VenueHome? {
		return venues.filter({
			location.latitude == $0.location?.latitude && location.longitude == $0.location?.longitude
		})[0]
	}

	var selectedVenue: VenueHome?

	func detailViewControllerModel() -> DetailViewControllerModel? {
		guard let venuesDetail = selectedVenue?.venuesDetail else { return nil }
		return DetailViewControllerModel(venue: venuesDetail)
	}
}
