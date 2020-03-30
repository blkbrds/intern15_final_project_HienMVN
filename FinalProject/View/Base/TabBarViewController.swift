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
	// MARK: - Private
	private func setupTabBar() {
		let homeVC = HomeViewController()
		let homeNaVi = UINavigationController(rootViewController: homeVC)
		let favoriteVC = FavoriteViewController()
		favoriteVC.viewModel = FavoriteViewControllerModel()
		let favoriteNavi = UINavigationController(rootViewController: favoriteVC)
		homeVC.tabBarItem = UITabBarItem(title: "Map", image: #imageLiteral(resourceName: "map"), tag: 0)
		favoriteVC.tabBarItem = UITabBarItem(title: "Favorite", image: #imageLiteral(resourceName: "heart"), tag: 1)
		self.viewControllers = [homeNaVi, favoriteNavi]
		self.selectedIndex = 0
		self.tabBar.unselectedItemTintColor = .black
		self.tabBar.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)

		let appearance = UITabBarItem.appearance()
		appearance.setBadgeTextAttributes([NSAttributedString.Key.strokeColor: UIColor.systemPink], for: .normal)
		appearance.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], for: .normal)
	}
}
