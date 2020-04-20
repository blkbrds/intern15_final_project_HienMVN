import UIKit
import Realm
import RealmSwift
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.backgroundColor = .white
		let vc = TabBarViewController()
		window?.rootViewController = vc
		window?.makeKeyAndVisible()
		LocationManager.shared.request()
		return true
	}

	private func configHUD() {
		SVProgressHUD.setDefaultStyle(.custom)
		SVProgressHUD.setDefaultMaskType(.custom)
		SVProgressHUD.setBackgroundLayerColor(UIColor.black.withAlphaComponent(0.5))
	}
}
