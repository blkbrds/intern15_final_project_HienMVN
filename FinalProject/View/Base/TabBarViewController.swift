//
//  TabBarViewController.swift
//  FinalProject
//
//  Created by Ngoc Hien on 3/11/20.
//  Copyright © 2020 Asian Tech Inc.,. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
	
	//MARK: - Life
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTabBar()
	}
	//MARK: - private Func
	private func setupTabBar() {
		let homeVC = HomeViewController()
		let homeNaVi = UINavigationController(rootViewController: homeVC)
		let favoriteVC = FavoriteViewController()
		let favoriteNavi = UINavigationController(rootViewController: favoriteVC)
		homeVC.tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "map"), tag: 0)
		favoriteVC.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(named: "heart"), tag: 1)
		self.viewControllers = [homeNaVi, favoriteNavi]
		self.selectedIndex = 0
		self.tabBar.unselectedItemTintColor = .black
		self.tabBar.tintColor = UIColor(red: 240.0 / 255.0, green: 136.0 / 255.0, blue: 101.0 / 255.0, alpha: 1.0)

		let appearance = UITabBarItem.appearance()
		appearance.setBadgeTextAttributes([NSAttributedString.Key.strokeColor: UIColor.systemPink], for: .normal)
		appearance.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], for: .normal)
	}
}
