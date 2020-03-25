import Foundation
import CoreLocation

final class HomeViewModel {

	// MARK: - Prperties
	private(set) var venues: [Venue] = []

	// MARK: - Public Methods
	func getVenues(currentLocation: CLLocationCoordinate2D, completion: @escaping APICompletion) {
		print(currentLocation)
		Api.Venue.getHomeData(lat: currentLocation.latitude, long: currentLocation.longitude) { [weak self] (result) in
			guard let self = self else { return }
			switch result {
			case .failure(let error):
				completion(.failure(error))
			case .success(let venueResult):
				self.venues = venueResult.venues
				completion(.success)
			}
		}
	}

	func getVenue(at location: CLLocationCoordinate2D) -> Venue? {
		return venues.filter({
			location.latitude == $0.location?.latitude && location.longitude == $0.location?.longitude
		})[0]
	}

	var selectedVenue: Venue?

	func detailViewControllerModel() -> DetailViewControllerModel? {
		guard let selectedVenue = selectedVenue else { return nil }
		return DetailViewControllerModel(venue: selectedVenue)
	}
}
