import MVVM
import Foundation
import UIKit

typealias DowloadImageCompletion = (UIImage?) -> Void

final class DetailViewModel: ViewModel {

	private(set) var venus: [Venue] = []

	func numberOfIteam() -> Int {
		return venus.count
	}

	init(_ venus: [Venue] = []) {
		self.venus = venus
	}

	func updateViewModelForCell(at indexPath: IndexPath) -> LocationViewCellModel {
		guard let name = venus[indexPath.row].name, let address = venus[indexPath.row].country, let locationImageURL = venus[indexPath.row].prefix else {
			return LocationViewCellModel()
		}
		return LocationViewCellModel(locationName: name, locationImageURL: locationImageURL, address: address)
	}
}
