import UIKit
import MVVM
import SwiftUtils

class ViewController: UIViewController, MVVM.View {

	// MARK: - Properties
	var isViewEmpty: Bool = false

	// MARK: - Setup Data, UI
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		view.accessibilityIdentifier = String(describing: type(of: self))
		view.removeMultiTouch()
		setupData()
		setupUI()
	}

	// MARK: - Public
	func setupData() { }

	func setupUI() { }
}
