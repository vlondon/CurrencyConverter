//
//  AppDelegate.swift
//  CurrencyConverter
//
//  Created by Vladimirs Matusevics on 03/10/2017.
//  Copyright © 2017 vmatusevic. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let mainWindow = UIWindow(frame: UIScreen.main.bounds)
        self.window = mainWindow
        
        mainWindow.backgroundColor = UIColor.white
        mainWindow.makeKeyAndVisible()
        
        let dependencies = Dependencies.createContainers()
        
        dependencies.converterDisplayable.display(in: mainWindow)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
    
}

