import Foundation

extension Api.Venue {
	struct VenueResult {
		var venues: [Venue]
	}

	struct QueryString {
		static func getVenue(lat: Double, long: Double) -> String {
			return Api.Path.Venue.venueURL + "\(lat),\(long)"
		}
	}

	static func getHomeData(lat: Double, long: Double, completion: @escaping Completion<VenueResult>) {
		let urlString: String = QueryString.getVenue(lat: lat, long: long)
		api.request(method: .get, urlString: urlString) { (resutl) in
			DispatchQueue.main.async {
				switch resutl {
				case .failure(let error):
					completion(.failure(error))
				case .success(let json):
					guard let json = json as? JSObject,
						let response = json["response"] as? JSObject,
						let result = response["venues"] as? JSArray

						else {
							completion(.failure(Api.Error.json))
							return }

					var venues: [Venue] = []
					for item in result {
						let venue = Venue(json: item)
						venues.append(venue)
					}
					let venueResult = VenueResult(venues: venues)
					completion(.success(venueResult))
				}
			}
		}
	}
}
