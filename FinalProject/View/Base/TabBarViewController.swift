import UIKit

final class TabBarViewController: UITabBarController {

	// MARK: - Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTabBar()
	}

	private func setupTabBar() {
		let homeVC = HomeViewController()
		let homeNaVi = UINavigationController(rootViewController: homeVC)
		let favoriteVC = FavoriteViewController()
		let favoriteNavi = UINavigationController(rootViewController: favoriteVC)
		homeVC.tabBarItem = UITabBarItem(title: "Map", image: #imageLiteral(resourceName: "map"), tag: 0)
		favoriteVC.tabBarItem = UITabBarItem(title: "Favorite", image: #imageLiteral(resourceName: "icons8-heart-49"), tag: 1)
		viewControllers = [homeNaVi, favoriteNavi]
		selectedIndex = 0
		tabBar.unselectedItemTintColor = .black
		tabBar.tintColor = #colorLiteral(red: 0, green: 0.5843623281, blue: 1, alpha: 1)
		navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.isTranslucent = true
		let appearance = UITabBarItem.appearance()
		appearance.setBadgeTextAttributes([NSAttributedString.Key.strokeColor: UIColor.systemPink], for: .normal)
		appearance.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], for: .normal)
	}
}
