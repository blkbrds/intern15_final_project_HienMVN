import Foundation
import CoreLocation

final class HomeViewModel {

	// MARK: - Prperties
	private(set) var venues: [VenueHome] = []

	// MARK: - Public Methods
	func getVenues(currentLocation: CLLocationCoordinate2D, completion: @escaping APICompletion) {
		print(currentLocation)
		Api.VenueHome.getHomeData(lat: currentLocation.latitude, long: currentLocation.longitude) { [weak self] (result) in
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

	func getVenue(at location: CLLocationCoordinate2D) -> VenueHome? {
		return venues.filter({
			location.latitude == $0.location?.latitude && location.longitude == $0.location?.longitude
		})[0]
	}

	var selectedVenue: VenueHome?

	func detailViewControllerModel() -> DetailViewControllerModel? {
		guard let selectedVenue = selectedVenue else { return nil }
		return DetailViewControllerModel(venueId: selectedVenue.id ?? "")
	}
}
