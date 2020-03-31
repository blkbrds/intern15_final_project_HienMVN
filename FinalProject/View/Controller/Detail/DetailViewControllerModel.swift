import Foundation
import CoreLocation
import RealmSwift

final class DetailViewControllerModel {

	// MARK: - Prperties
	var venueDetail: VenueDetail
	
	init(venue: VenueDetail) {
		self.venueDetail = venue
	}

	// MARK: - Add For Realm
	func addRealm(data: VenueDetail) {
		do {
			let realm = try Realm()
			try realm.write {
				let data = data
				realm.add(data)
			}
		} catch {
			print("Lỗi thêm đối tượng vào Realm")
		}
	}

	// MARK: - Update For Realm
	func updateRealm(isFavorite: Bool) {
		do {
			// realm
			let realm = try Realm()
			// edit
			try realm.write {
				venueDetail.favorite = isFavorite
			}
		} catch {
			print("Lỗi edit đối tượng 🇺🇸")

		}
	}

	// MARK: - Get Realm
	func getRealm() -> Results<VenueDetail>? {
		do {
			let realm = try Realm()
			let listVenueDetail: Results<VenueDetail> = { realm.objects(VenueDetail.self) }()
			return listVenueDetail
		} catch {
			print("Lỗi GET đối tượng 🇺🇸")
			return nil
		}

	}

	// MARK: - Update Favorite Realm
	func didUpdateFavorite(isFav: Bool) {
		addRealm(data: venueDetail)
		updateRealm(isFavorite: isFav)
	}

	// MARK: - Prperties
//	let venueId: String

//	// MARK: - init
//	init(venueId: String) {
//		self.venueId = venueId
//	}
//
//	// MARK: - Public Methods
//	func getItems(completion: @escaping APICompletion) {
//		if let item = venues?.first(where: { ($0.venuesDetail == venueDetail) }) {
//			self.venueDetail = item.venuesDetail
//			completion(.success)
//		} else {
//			Api.VenueDetail.getItem(id: venueId) { [weak self] (result) in
//				guard let this = self else { return }
//				DispatchQueue.main.async {
//					switch result {
//					case .failure(let error):
//						completion(.failure(error))
//					case .success(let data):
//						this.venueDetail = data
//						this.addRealm(data: data)
//						completion(.success)
//					}
//				}
//			}
//		}
//	}
}
