import Foundation

typealias GetLocationCompletion = (Bool, String) -> Void

final class HomeViewModel {
	// MARK: - Prperties
	private(set) var venues: [Venue] = []

	// MARK: - Public
	func getLocation(completion: @escaping GetLocationCompletion) {
		let latDaNang: Double = 16.04362
		let lngDaNang: Double = 108.1836936
		Api.Venue.getHomeData(lat: latDaNang, long: lngDaNang) { (result) in
			switch result {
			case .failure(let error):
				completion(false, error.localizedDescription)
			case .success(let venueResult):
				self.venues.append(contentsOf: venueResult.venues)
				completion(true, "")
			}
		}
	}

}
