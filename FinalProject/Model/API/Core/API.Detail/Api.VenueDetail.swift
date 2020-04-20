import Foundation
import ObjectMapper

extension Api.VenueDetail {
	struct ItemResult {
		var venus = VenueDetail()
	}

	struct QueryString {
		static func getUrlString(id: String) -> String {
			let clientInfor: (idClient: String, passClient: String) = URLClient.getClientInfor()
			return Api.Path.VenueDetail.itemURL + "/\(id)" + clientInfor.idClient + clientInfor.passClient + "&ll=16.0776738%2C108.197205&v=20162502"
		}
	}

	// MARK: - Static Method
	static func getVenueDetail(id: String, completion: @escaping DataCompletion<VenueDetail>) {
		DispatchQueue.global(qos: .background).sync {
			let urlString: String = QueryString.getUrlString(id: id)
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
}
