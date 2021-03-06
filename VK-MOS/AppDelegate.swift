//
//  AppDelegate.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 20.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.setUpProject()
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

extension AppDelegate{
    
    func setUpProject(){
        self.printProjectSettings()
        self.setupLogger()
        self.setupSDWebImage()
        self.setupSVProgressHUD()
        self.setupAppearance()
        
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
    }
    
    func setupAppearance() {
        
        let navigationBar = UINavigationBar.appearance()
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationBar.barTintColor = AppColors.MainColor
        navigationBar.tintColor = UIColor.white
        navigationBar.isTranslucent = false
    }
    
    func printProjectSettings() {
        #if DEBUG
            // print documents directory and device ID
            print("\n*******************************************\nDOCUMENTS:\n\(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])\n*******************************************\n")
            print("\n*******************************************\nDEVICE ID:\n\((UIDevice.current.identifierForVendor?.uuidString)!)\n*******************************************\n")
            print("\n*******************************************\nBUNDLE ID:\n\((Bundle.main.bundleIdentifier)!)\n*******************************************\n")
        #endif
    }
    
    func setupLogger() {
        Logger.setup(level: .debug, showLogIdentifier: false, showFunctionName: false, showThreadName: true, showLevel: false, showFileNames: true, showLineNumbers: true, showDate: true, writeToFile: nil, fileLevel: .none)
        
        Logger.dateFormatter?.dateFormat = "HH:mm:ss.SSS"
        
        print()
    }
    
    func setupSDWebImage() {
        let imageCache:SDImageCache = SDImageCache.shared()
        imageCache.maxCacheSize     = UInt(1024*1024*50) // 100mb on disk
        imageCache.maxMemoryCost    = UInt(1024*1024*10)  // 10mb in memory
        
        let imageDownloader:SDWebImageDownloader = SDWebImageDownloader.shared()
        imageDownloader.downloadTimeout          = 60.0
    }
    
    func setupSVProgressHUD() {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
    }
}
