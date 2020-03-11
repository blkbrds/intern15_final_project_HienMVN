//
//  AppDelegate.swift
//  FinalProject
//
//  Created by Tung Nguyen C.T. on 3/11/20.
//  Copyright © 2020 Asian Tech Inc.,. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let vc = HomeViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }

}
