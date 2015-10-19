//
//  AppDelegate.swift
//  AED
//
//  Created by Yang Yu on 10/6/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        CrashReporter.sharedInstance().enableLog(true)
        CrashReporter.sharedInstance().installWithAppId("cn.com.ito.AED")
        return true
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let _ = defaults.stringForKey("isAppAlreadyLaunchedOnce"){
            print("App already launched")
            return true
        }else{
            defaults.setBool(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
}

