import MVVM
import Foundation
import UIKit

final class DetailViewModel: ViewModel {

	private(set) var venuesHome: [VenueHome] = []
	private(set) var venuesDetail: [VenueDetail] = []

	func numberOfIteam() -> Int {
		return venuesHome.count
	}

	init(_ venuesHome: [VenueHome] = [], _ venuesDetail: [VenueDetail] = []) {
			self.venuesHome = venuesHome
		self.venuesDetail = venuesDetail
		}

		func getIndexPathVenus(id: String) -> IndexPath? {
			if let index = venuesHome.map({ $0.id }).firstIndex(of: id) {
				return IndexPath(item: index, section: 0)
			}
			return nil
		}

		func updateInformationForCell(at indexPath: IndexPath) -> LocationViewCellModel {
			guard let name = venuesHome[indexPath.row].name,
				let country = venuesHome[indexPath.row].country
				else {
					return LocationViewCellModel()
			}
			let prefixDetail = venuesDetail[indexPath.row].prefix
			let suffixDetail = venuesDetail[indexPath.row].suffix
			let locationImageURL = venuesHome[indexPath.row].prefix
			return LocationViewCellModel(locationName: name, locationImageURL: locationImageURL ?? "", country: country, suffix: suffixDetail ?? "", prefix: prefixDetail ?? "")
		}
	}
