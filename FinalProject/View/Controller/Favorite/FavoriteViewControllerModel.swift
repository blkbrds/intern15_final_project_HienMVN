import Foundation
import RealmSwift

final class FavoriteViewControllerModel {

// MARK: - Public Method
	func getCellViewModel(at indexPath: IndexPath) -> FavoriteTableViewCellModel? {
		guard let listFavorite = RealmManager.shared.listItemFavorite else { return nil }
		return FavoriteTableViewCellModel(locationName: listFavorite[indexPath.row].name ?? "",
			address: listFavorite[indexPath.row].address ?? "",
			suffix: listFavorite[indexPath.row].suffix ?? "",
			prefix: listFavorite[indexPath.row].prefix ?? "")
	}

	func detailViewControllerModel(at indexPath: IndexPath) -> DetailViewControllerModel? {
		guard let listFavorite = RealmManager.shared.listItemFavorite else { return nil }
		let venue = listFavorite[indexPath.row]
		return DetailViewControllerModel(venue: venue, id: venue.id)
	}
}
