import Foundation
import CoreLocation
typealias APIvenueCompletion = (Bool, String?) -> Void

final class HomeViewModel {

	// MARK: - Prperties
	private(set) var venues: [Venue] = []

	// MARK: - Public Methods
	func getVenues(currentLocation: CLLocationCoordinate2D, completion: @escaping APIvenueCompletion) {
		Api.Venue.getHomeData(lat: currentLocation.latitude, long: currentLocation.longitude) { [weak self] (result) in
			guard let self = self else { return }
			switch result {
			case .failure(let error):
				completion(false, error.localizedDescription)
			case .success(let venueResult):
				self.venues = venueResult.venues
				completion(true, nil)
			}
		}
	}

}