//
//  AppDelegate.swift
//  Brewge
//
//  Created by Jonathan Hooper on 8/11/15.
//  Copyright (c) 2015 JonathanHooper. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        AppTheme.setAppTheme()
        return true
    }

}

