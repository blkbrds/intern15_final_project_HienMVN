import Foundation
import CoreLocation

final class HomeViewModel {

	// MARK: - Prperties
	private(set) var venues: [Venue] = []

	// MARK: - Public Methods
	func getVenues(currentLocation: CLLocationCoordinate2D, completion: @escaping APICompletion) {
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
}
