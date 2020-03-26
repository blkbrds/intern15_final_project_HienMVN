import MVVM
import Foundation
import UIKit

final class DetailViewModel: ViewModel {

	private(set) var venues: [VenueHome] = []

	func numberOfIteam() -> Int {
		return venues.count
	}

	init(_ venus: [VenueHome] = []) {
		self.venues = venus
	}

	func getIndexPathVenus(id: String) -> IndexPath? {
		if let index = venues.map({ $0.id }).firstIndex(of: id) {
			return IndexPath(item: index, section: 0)
		}
		return nil
	}

	func updateInformationForCell(at indexPath: IndexPath) -> LocationViewCellModel {
		guard let name = venues[indexPath.row].name, let country = venues[indexPath.row].country else {
			return LocationViewCellModel(locationImageURL: "")
		}
		let locationImageURL = venues[indexPath.row].prefix
		return LocationViewCellModel(locationName: name, locationImageURL: locationImageURL ?? "", country: country)
	}
}
