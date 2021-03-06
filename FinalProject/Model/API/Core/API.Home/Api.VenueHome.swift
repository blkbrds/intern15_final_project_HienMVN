import Foundation

extension Api.VenueHome {
	struct VenueResult {
		var venues: [VenueHome]
	}

	struct QueryString {
		static func getVenue(lat: Double, long: Double, limit: Int, query: String) -> String {
			return Api.Path.VenueHome.venueURL + "\(lat),\(long)&limit=\(limit)&query=\(query)"
		}
	}

	static func getHomeData(lat: Double, long: Double, limit: Int, query: String, completion: @escaping DataCompletion<VenueResult>) {
		let urlString: String = QueryString.getVenue(lat: lat, long: long, limit: limit, query: query)
		api.request(method: .get, urlString: urlString) { (resutl) in
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

				var venues: [VenueHome] = []
				for item in result {
					let venue = VenueHome(json: item)
					venues.append(venue)
				}
				let venueResult = VenueResult(venues: venues)
				completion(.success(venueResult))
			}
		}
	}
}
