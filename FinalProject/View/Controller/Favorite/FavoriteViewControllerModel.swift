import Foundation
import RealmSwift

final class FavoriteViewControllerModel {

// MARK: - Public Method
	func getFavoriteTableViewCellModel(at indexPath: IndexPath) -> FavoriteTableViewCellModel? {
		guard let listFavorite = RealmManager.shared.listItemFavorite else { return nil }
		return FavoriteTableViewCellModel(locationName: listFavorite[indexPath.row].name,
										  address: listFavorite[indexPath.row].address,
										  timeOpen: listFavorite[indexPath.row].openTime,
										  like: listFavorite[indexPath.row].countOfLike,
										  rating: listFavorite[indexPath.row].rating,
			suffix: listFavorite[indexPath.row].suffix ?? "",
			prefix: listFavorite[indexPath.row].prefix ?? "")
	}

	func detailViewControllerModel(at indexPath: IndexPath) -> DetailViewControllerModel? {
		guard let listFavorite = RealmManager.shared.listItemFavorite else { return nil }
		let venue = listFavorite[indexPath.row]
		return DetailViewControllerModel(venue: venue, id: venue.id)
	}
}
