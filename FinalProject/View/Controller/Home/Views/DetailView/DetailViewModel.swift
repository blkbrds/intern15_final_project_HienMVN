import Foundation
import UIKit

typealias ItemCompletion = (Bool, String) -> Void
typealias dowloadImageCompletion = (UIImage)

final class DetailViewModel {

	private(set) var items: [Item] = []

	func getItem(id: String, completion: @escaping ItemCompletion) {
		Api.Item.getItem(id: id) {
			[weak self] (result) in
			guard let self = self else { return }
			switch result {
			case .failure(let error):
				completion(false, error.localizedDescription)
			case.success(let itemResult):
				self.items.append(contentsOf: itemResult.item)
			}
		}
	}
}
