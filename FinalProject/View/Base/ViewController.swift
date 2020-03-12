import UIKit
import MVVM
import SwiftUtils

class ViewController: UIViewController, MVVM.View {

	// Conformance for ViewEmptyProtocol
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

	// MARK: - Setup Data, UI
	func setupData() { }

	func setupUI() { }
}
