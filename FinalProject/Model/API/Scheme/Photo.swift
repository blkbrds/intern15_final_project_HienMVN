import Foundation

final class Item {
	var prefix: String?
	var suffix: String?
	var width: String?
	var hight: String?
	init(json: JSON) {
		prefix = json["prefix"] as? String
		suffix = json["suffix"] as? String
		width = json["width"] as? String
		hight = json["hight"] as? String
	}
}
