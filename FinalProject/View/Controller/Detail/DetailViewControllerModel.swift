import Foundation
import CoreLocation
import RealmSwift

protocol DetailViewControllerModelDelegate: class {
	func passData(with item: VenueDetail, favoriting: Bool)
}

final class DetailViewControllerModel {

	// MARK: - Prperties
	var item: VenueDetail?
	weak var delegate: DetailViewControllerModelDelegate?

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

	func updateRealm(isFavorite: Bool) {
		do {
			guard let item = item else { return }
			// realm
			let realm = try Realm()
			// edit
			try realm.write {
				item.favorite = isFavorite
			}
		} catch {
			print("Lỗi edit đối tượng 🇺🇸")

		}
	}

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

	// MARK: - Prperties
	let venueId: String

	// MARK: - init
	init(venueId: String, delegate: DetailViewControllerModelDelegate?) {
		self.venueId = venueId
		self.delegate = delegate
	}

	// MARK: - Public Methods
	func getItems(completion: @escaping APICompletion) {
		if let item = getRealm()?.first(where: { ($0.id == venueId) }) {
			self.item = item
			completion(.success)
		} else {
			Api.VenueDetail.getItem(id: venueId) { [weak self] (result) in
				guard let this = self else { return }
				DispatchQueue.main.async {
					switch result {
					case .failure(let error):
						completion(.failure(error))
					case .success(let data):
						this.item = data
						this.addRealm(data: data)
						completion(.success)
					}
				}
			}
		}
	}

	func didUpdateFavorite(isFav: Bool) {
		updateRealm(isFavorite: isFav)
	}
}
