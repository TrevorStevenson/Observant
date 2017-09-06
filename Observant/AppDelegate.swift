//
//  AppDelegate.swift
//  Observant
//
//  Created by Trevor Stevenson on 9/28/14.
//  Copyright (c) 2014 ncunited. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var leaderboardIdentifier: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let defaults = UserDefaults.standard
        
        if (defaults.integer(forKey: "firstTime") == 0)
        {
            defaults.set(3, forKey: "hints")
            defaults.set(3, forKey: "fifty")
            defaults.set(0, forKey: "highScore")
            
            defaults.set(true, forKey: "showAds")
            
            let alert = UIAlertView(title: "Welcome", message: "To play, memorize the board of numbers. After 10 seconds, one number will change. Select that number to move on.", delegate: self, cancelButtonTitle: "Ok")
            
            alert.show()
                        
            defaults.set(1, forKey: "firstTime")
            
            defaults.synchronize()
        }
        
        return true
    }

}

