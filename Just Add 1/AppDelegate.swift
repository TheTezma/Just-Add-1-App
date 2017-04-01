//
//  AppDelegate.swift
//  Just Add 1
//
//  Created by Chris Richards on 20/12/2016.
//  Copyright © 2016 Chris Richards. All rights reserved.
//

//          ,--.,--. ,--. ,---. ,--------.      ,---.  ,------.  ,------.       ,--.
//          |  ||  | |  |'   .-''--.  .--'     /  O  \ |  .-.  \ |  .-.  \     /   |
//     ,--. |  ||  | |  |`.  `-.   |  |       |  .-.  ||  |  \  :|  |  \  :    `|  |
//     |  '-'  /'  '-'  '.-'    |  |  |       |  | |  ||  '--'  /|  '--'  /     |  |
//      `-----'  `-----' `-----'   `--'       `--' `--'`-------' `-------'      `--'

//      _____ _          _       _____  _      _                   _
//     / ____| |        (_)     |  __ \(_)    | |                 | |
//    | |    | |__  _ __ _ ___  | |__) |_  ___| |__   __ _ _ __ __| |___
//    | |    | '_ \| '__| / __| |  _  /| |/ __| '_ \ / _` | '__/ _` / __|
//    | |____| | | | |  | \__ \ | | \ \| | (__| | | | (_| | | | (_| \__ \
//     \_____|_| |_|_|  |_|___/ |_|  \_\_|\___|_| |_|\__,_|_|  \__,_|___/
import UIKit
import GoogleMobileAds
import Alamofire
import Flurry_iOS_SDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Flurry.startSession("5RCMYR7MF2GZ8KR5T95C", with: FlurrySessionBuilder
            .init()
            .withCrashReporting(true)
            .withLogLevel(FlurryLogLevelAll))
        // Override point for customization after application launch.
        GADMobileAds.configure(withApplicationID: "ca-app-pub-9891054964508855/5364308922")
        GADMobileAds.configure(withApplicationID: "ca-app-pub-9891054964508855/3808018122")
        return true
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

