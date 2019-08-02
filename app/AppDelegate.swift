//
//  AppDelegate.swift
//  libjeid-ios-app
//
//  Copyright © 2019 Open Source Solution Technology Corporation
//  All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let naviController = UINavigationController(rootViewController: MainViewController())
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = naviController
        self.window?.makeKeyAndVisible()
        return true
    }

}

