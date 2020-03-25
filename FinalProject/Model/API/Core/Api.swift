import Foundation
import Alamofire

final class Api {

	struct Path {
		static let baseURL = "https://api.foursquare.com"
		static let version = "v2"
	}

	struct Venue { }
	// venues for detail
	struct Item { }
}

extension Api.Path {
	struct Venue {
		static let path: String = baseURL / version
		static let venueURL: String = path / "venues" / "search?client_id=U15EYIZEPQYA1J4OD4RDOX3AODLXS2BEVPB0Q50MDV51CIQL&client_secret=Z11A3B140OMH0NZEMM2URPCCFEE1FVPB0YEPAOD5G3NB1DXE&v=20130815&ll="
	}
	struct Item {
		static let path: String = baseURL / version
		static let itemURL: String = path / "venues"
	}
}

protocol URLStringConvertible {
	var urlString: String { get }
}

protocol ApiPath: URLStringConvertible {
	static var path: String { get }
}

private func / (lhs: URLStringConvertible, rhs: URLStringConvertible) -> String {
	return lhs.urlString + "/" + rhs.urlString
}

extension String: URLStringConvertible {
	var urlString: String { return self }
}

private func / (left: String, right: Int) -> String {
	return left.appending(path: "\(right)")
}
