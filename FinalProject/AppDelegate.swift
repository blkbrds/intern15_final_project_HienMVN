import UIKit
import Realm
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let realm = try? Realm()
		print(realm?.configuration.fileURL)
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.backgroundColor = .white
		let vc = TabBarViewController()
		window?.rootViewController = vc
		window?.makeKeyAndVisible()
		LocationManager.shared.request()
		return true
	}
}
