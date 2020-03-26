//
//  FavoriteTableViewCell.swift
//  FinalProject
//
//  Created by Ngoc Hien on 3/25/20.
//  Copyright © 2020 Asian Tech Inc.,. All rights reserved.
//

import UIKit

final class FavoriteTableViewCell: UITableViewCell {

	// MARK: - Outlets
	@IBOutlet weak private var addressLabel: UILabel!
	@IBOutlet weak private var favoriteImageView: UIImageView!
	@IBOutlet weak private var nameLabel: UILabel!

	// MARK: - Life Cycle
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}
