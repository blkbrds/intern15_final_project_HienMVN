import Foundation
import Alamofire

final class Api {

	struct Path {
		static let baseURL = "https://api.foursquare.com"
		static let version = "v2"
	}

	struct VenueHome { }
	// venues for detail
	struct VenueDetail { }
}

extension Api.Path {
	struct VenueHome {
		static let path: String = baseURL / version
		static let venueURL: String = path / "venues" / "search?client_id=E5LY2IS5QDA5G1KKIAE3XXK0OGD4T3L1U2TWT4LZFGWAMEOD&client_secret=PELFEG4UP21Q1PHTCD3IZXOQPV0RII4NI5SR4MHRTKP0SXF3&v=20130815&ll="
	}
	struct VenueDetail {
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
