import Foundation
import RealmSwift

final class FavoriteViewControllerModel {

// MARK: - Properties
	var listItemFavorite: Results<VenueDetail>?

	// MARK: - FetchData Method
	func fetchDataRealm(completion: (Bool) -> Void) {
		do {
			// realm
			let realm = try Realm()
			listItemFavorite = realm.objects(VenueDetail.self).filter("favorite = true")
			completion(true)
		} catch {
			completion(false)
		}
	}

	// MARK: - Fetch Data Method
	func deleteAllDataRealm(completion: (Bool) -> Void) {
		do {
			// realm
			let realm = try Realm()
			listItemFavorite = realm.objects(VenueDetail.self).filter("favorite = true")

			try realm.write {
				guard let listFavorite = listItemFavorite else { return }
				realm.delete(listFavorite)
			}
			completion(true)
		} catch {
			completion(false)
		}
	}

	// MARK: - Delete Data Method
	func deleteObjectRealm(at indexPath: Int, completion: (Bool) -> Void) {
		do {
			// realm
			let realm = try Realm()
			listItemFavorite = realm.objects(VenueDetail.self).filter("favorite = true")
			var itemFavorite: VenueDetail?
			guard let listItemFavorite = listItemFavorite else { return }
			for index in 0..<listItemFavorite.count where index == indexPath {
				itemFavorite = listItemFavorite[index]
			}
			try realm.write {
				guard let itemFavorite = itemFavorite else { return }
				realm.delete(itemFavorite)
			}
			completion(true)
		} catch {
			completion(false)
		}
	}

// MARK: - Private Method
	func getCellViewModel(at indexPath: IndexPath) -> FavoriteTableViewCellModel? {
		guard let listFavorite = listItemFavorite else { return nil }
		return FavoriteTableViewCellModel(locationName: listFavorite[indexPath.row].name ?? "",
			address: listFavorite[indexPath.row].address ?? "",
			suffix: listFavorite[indexPath.row].suffix ?? "",
			prefix: listFavorite[indexPath.row].prefix ?? "")

	}
}
