//
//  TabBarViewController.swift
//  FinalProject
//
//  Created by Ngoc Hien on 3/11/20.
//  Copyright © 2020 Asian Tech Inc.,. All rights reserved.
//

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

	func makeNavigationBarTransparent(isTranslucent: Bool = true) {
		if let navBar = navigationController?.navigationBar {
			let blankImage = UIImage()
			navBar.setBackgroundImage(blankImage, for: .default)
			navBar.shadowImage = blankImage
			navBar.isTranslucent = isTranslucent
		}
	}
	// MARK: - Private
	private func setupTabBar() {
		let homeVC = HomeViewController()
		let homeNaVi = UINavigationController(rootViewController: homeVC)
		let favoriteVC = FavoriteViewController()
		favoriteVC.viewModel = FavoriteViewControllerModel()
		let favoriteNavi = UINavigationController(rootViewController: favoriteVC)
		homeVC.tabBarItem = UITabBarItem(title: "Map", image: #imageLiteral(resourceName: "map"), tag: 0)
		favoriteVC.tabBarItem = UITabBarItem(title: "Favorite", image: #imageLiteral(resourceName: "heart"), tag: 1)
		viewControllers = [homeNaVi, favoriteNavi]
		selectedIndex = 0
		tabBar.unselectedItemTintColor = .black
		tabBar.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)

		navigationController?.setNavigationBarHidden(false, animated: false)
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.navigationBar.isTranslucent = true
		navigationController?.view.backgroundColor = UIColor.clear
		let appearance = UITabBarItem.appearance()
		appearance.setBadgeTextAttributes([NSAttributedString.Key.strokeColor: UIColor.systemPink], for: .normal)
		appearance.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], for: .normal)
	}
}
