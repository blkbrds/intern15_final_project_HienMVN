import Foundation
import RealmSwift

class RealmManager {

	// MARK: - Singerton
	static let shared: RealmManager = {
		return RealmManager()
	}()

	// MARK: - Properties
	var listItemFavorite: Results<VenueDetail>?
	let realm = try? Realm()

	// MARK: - FetchData Method
	func fetchDataRealm(completion: (Bool) -> Void) {
		do {
			// realm
			let realm = try Realm()
			listItemFavorite = realm.objects(VenueDetail.self)
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
			listItemFavorite = realm.objects(VenueDetail.self)

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
			listItemFavorite = realm.objects(VenueDetail.self)
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

	// MARK: - Add For Realm
	func addRealm(data: VenueDetail) {
		do {
			guard let realm = realm else { return }
			try realm.write {
				let data = data
				realm.create(VenueDetail.self, value: data, update: .all)
			}
		} catch {
			print("Lỗi thêm đối tượng vào Realm")
		}
	}
}
