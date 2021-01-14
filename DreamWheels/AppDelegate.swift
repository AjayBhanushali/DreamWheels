//
//  AppDelegate.swift
//  DreamWheels
//
//  Created by Ajay on 14/01/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Setting up Root View Controller for the app
        window = UIWindow(frame: UIScreen.main.bounds)
        AppBuilder().setRootViewController(in: window)
        return true
    }
}

