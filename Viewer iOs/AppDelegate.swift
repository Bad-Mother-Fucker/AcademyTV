//
//  AppDelegate.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 15/10/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications

@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    let query = CKQuery(recordType: "GlobalMessages", predicate: NSPredicate(value: true))

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.badge]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (autorized, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if autorized {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                    UNUserNotificationCenter.current().delegate = self
                    CKController.saveSubscription(for: GlobalMessage.recordType, ID: CKKeys.messageSubscriptionKey)
                    CKController.saveSubscription(for: TV.recordType, ID: CKKeys.tvSubscriptionKey)
                }
            }
        }

        // Override point for customization after application launch.
        let recordQuery = CKQuery(recordType: UsageStatistics.recordType, predicate: NSPredicate(format: "recordCode == %@", "com.Rogue.Viewer.UsageStats"))
        CKKeys.database.perform(recordQuery, inZoneWith: nil) { (records, error) in
            guard records != nil else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            guard records!.count > 0 else {
                UsageStatistics.shared.record.setValue("com.Rogue.Viewer.UsageStats", forKey: "recordCode")
                CKKeys.database.save(UsageStatistics.shared.record, completionHandler: { _, _  in
                    
                })
                
                return
            }
            UsageStatistics.shared.record = records!.first!
            
        }
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        NSLog("notification recieved")
        let notificationName: CKNotificationName
        if let info = userInfo as? [String: Any] {

            let ckqn = CKQueryNotification(fromRemoteNotificationDictionary: info)

            switch ckqn.subscriptionID {
            case CKKeys.tvSubscriptionKey:
                notificationName = .tv
            case CKKeys.messageSubscriptionKey:
                notificationName = .globalMessages
            case CKKeys.serviceSubscriptionKey:
                notificationName = .serviceMessage
            default:
                notificationName = .null
            }
            let notification = Notification(name: Notification.Name(rawValue: notificationName.rawValue),
                                            object: self,
                                            userInfo: [CKNotificationName.notification.rawValue: ckqn])
            NotificationCenter.default.post(notification)
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //        Save device token as TV property
        NSLog("registered for remote notifications")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog(error.localizedDescription)
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
        CKController.removeSubscriptions()
    }
}
