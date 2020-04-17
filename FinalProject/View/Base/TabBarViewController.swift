import UIKit

final class TabBarViewController: UITabBarController {

	// MARK: - Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTabBar()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		makeNavigationBarTransparent()
	}

	// MARK: - Private Methods
	private func makeNavigationBarTransparent(isTranslucent: Bool = true) {
		if let navBar = self.navigationController?.navigationBar {
			let blankImage = UIImage()
			navBar.setBackgroundImage(blankImage, for: .default)
			navBar.shadowImage = blankImage
			navBar.isTranslucent = isTranslucent
		}
	}

	private func setupTabBar() {
		let homeVC = HomeViewController()
		let homeNaVi = UINavigationController(rootViewController: homeVC)
		let favoriteVC = FavoriteViewController()
	//	favoriteVC.viewModel = FavoriteViewControllerModel()
		let favoriteNavi = UINavigationController(rootViewController: favoriteVC)
		homeVC.tabBarItem = UITabBarItem(title: "Map", image: #imageLiteral(resourceName: "map"), tag: 0)
		favoriteVC.tabBarItem = UITabBarItem(title: "Favorite", image: #imageLiteral(resourceName: "heart"), tag: 1)
		viewControllers = [homeNaVi, favoriteNavi]
		selectedIndex = 0
		tabBar.unselectedItemTintColor = .black
		tabBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		tabBar.backgroundImage = #imageLiteral(resourceName: "unnamed")
		navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
		let appearance = UITabBarItem.appearance()
		appearance.setBadgeTextAttributes([NSAttributedString.Key.strokeColor: UIColor.systemPink], for: .normal)
		appearance.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], for: .normal)
	}
}
