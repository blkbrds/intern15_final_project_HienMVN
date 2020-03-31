import Foundation
import ObjectMapper

extension Api.VenueDetail {
	struct ItemResult {
		var venus = VenueDetail()
	}

	struct QueryString {
		static func getItem(id: String) -> String {
			let idClient: String = "?client_id=CO20LM5PYICHT3EJRB434WNKKVV42RTMO1JPCOG5C4VR3N1W&client_"
			let secret: String = "secret=5IFDDFXM20J5FYNR3LEHGW4LVZQIRIE2S4PYBEEIGZUW0YYZ&ll"
			return Api.Path.VenueDetail.itemURL + "/\(id)" + idClient + secret + "=16.0776738%2C108.197205&v=20162502"
		}
	}

	// MARK: - Static Method
	static func getItem(id: String, completion: @escaping DataCompletion<VenueDetail>) {
		let urlString: String = QueryString.getItem(id: id)
		api.request(method: .get, urlString: urlString) { result in
			switch result {
			case .failure(let error):
				completion(.failure(error))
			case .success(let json):
				guard let json = json as? JSObject,
					let response = json["response"] as? JSObject,
					let venue = response["venue"] as? JSObject,
					let venueResponse = Mapper<VenueDetail>().map(JSONObject: venue) else {
						completion(.failure(Api.Error.json))
						return
				}
				completion(.success(venueResponse))
			}
		}
	}
}
