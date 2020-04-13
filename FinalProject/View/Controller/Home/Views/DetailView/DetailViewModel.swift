import MVVM
import Foundation
import UIKit

final class DetailViewModel: ViewModel {

	var venuesHome: [VenueHome] = []
	var venuesDetail: [VenueDetail] = []

	init(_ venuesHome: [VenueHome] = [], _ venuesDetail: [VenueDetail] = []) {
		self.venuesHome = venuesHome
		self.venuesDetail = venuesDetail
	}

	func numberOfItem() -> Int {
		return venuesDetail.count
	}

	func getIndexPathVenues(id: String?) -> IndexPath? {
		guard let id = id else { return nil }
		if let index = venuesDetail.firstIndex(where: { $0.id ?? "" == id }) {
			return IndexPath(item: index, section: 0)
		}
		return nil
	}

	func getLocationViewCellModel(at indexPath: IndexPath) -> LocationViewCellModel? {
		guard indexPath.row < venuesDetail.count else {
			return nil
		}
		let venueHome = venuesHome.first { (venueHome) -> Bool in
			return venuesDetail[indexPath.row].id == venueHome.id
		}
		return LocationViewCellModel(locationName: venueHome?.name,
			locationImageURL: venueHome?.prefix,
			country: venueHome?.country,
			suffix: venuesDetail[indexPath.row].suffix,
			prefix: venuesDetail[indexPath.row].prefix)
	}
}
