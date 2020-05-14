import UIKit
import Foundation

class CustomButton: UIButton {

	override init(frame: CGRect) {
		super.init(frame: frame)
		styleButton()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		styleButton()

	}

	private func styleButton() {
		setShadow()
		backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		layer.cornerRadius = 25
	}

	private func setShadow() {
		layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		layer.shadowOffset = CGSize(width: 0, height: 1.75)
		layer.shadowRadius = 1.75
		layer.shadowOpacity = 0.5
		clipsToBounds = true
		layer.masksToBounds = false
	}
}
