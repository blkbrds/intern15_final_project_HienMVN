import Foundation

extension Api.Item {
	struct ItemResult {
		var item: [Item]
	}

	struct QueryString {
		static func getItem(id: String) -> String {
			return Api.Path.Item.itemURL + "/\(id)/photos?oauth_token=3IHPZFJ0LWOKCHTHQMWAOZMX40VQV0S3PMZKNUMYZGHUP4WJ&v=20160524"
		}
	}

	static func getItem(id: String, completion: @escaping Completion<ItemResult>) {
		let urlString: String = QueryString.getItem(id: id)
		api.request(method: .get, urlString: urlString) { (result) in
			DispatchQueue.main.async {
				switch result {
				case .failure(let error):
					completion(.failure(error))
				case .success(let json):
					guard let json = json as? JSObject,
						let response = json["response"] as? JSObject,
						let photos = response["photos"] as? JSObject,
						let result = photos["items"] as? JSArray

						else {
							completion(.failure(Api.Error.json))
							return }

					var items: [Item] = []
					for item in result {
						let item = Item(json: item)
						items.append(item)
					}
					let itemResult = ItemResult(item: items)
					completion(.success(itemResult))
				}
			}
		}
	}
}
