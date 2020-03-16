import Foundation
import CoreLocation

typealias GetLocationCompletion = (Bool, String) -> Void

protocol HomeViewModelDelegate: class {
	func loadVenues(venues: [Venue])
	func showError(stringError: String)
}
final class HomeViewModel {
	// MARK: - Prperties
	private(set) var venues: [Venue] = []
	weak var delegate: HomeViewModelDelegate?

	// MARK: - Public
	func getVenues(currentLocation: CLLocationCoordinate2D) {
		Api.Venue.getHomeData(lat: currentLocation.latitude, long: currentLocation.longitude) {[weak self] (result) in
			guard let self = self else { return }
			switch result {
			case .failure(let error):
				self.delegate?.showError(stringError: error.localizedDescription)
			case .success(let venueResult):
				self.venues = venueResult.venues
				self.delegate?.loadVenues(venues: self.venues)
			}
		}
	}

}
