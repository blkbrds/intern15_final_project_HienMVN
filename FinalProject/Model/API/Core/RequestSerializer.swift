import Foundation
import Alamofire

extension ApiManager {

	@discardableResult
	func request(method: HTTPMethod, urlString: URLStringConvertible,
		parameters: [String: Any]? = nil,
		encoding: ParameterEncoding = URLEncoding.default,
		headers: [String: String]? = nil,
		completion: Completion<Any>?) -> Request? {
		guard Network.shared.isReachable else {
			completion?(.failure(Api.Error.network))
			return nil
		}

		var header = api.defaultHTTPHeaders
		header.updateValues(headers)

		let request = Alamofire.request(urlString.urlString,
			method: method,
			parameters: parameters,
			encoding: encoding,
			headers: header
		).responseJSON { (response) in
			// Fix bug AW-4571: Call request one more time when see error 53 or -1_005
			if let error = response.error,
				error.code == Api.Error.connectionAbort.code || error.code == Api.Error.connectionWasLost.code {
				Alamofire.request(urlString.urlString,
					method: method,
					parameters: parameters,
					encoding: encoding,
					headers: header
				).responseJSON { response in

					DispatchQueue.main.async {
						completion?(response.result)
					}
				}
			} else {
				DispatchQueue.main.async {
					completion?(response.result)
				}
			}
		}
		return request
	}
}
