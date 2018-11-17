//
//  AppDelegate.swift
//  Viewer
//
//  Created by Gianluca Orpello on 15/10/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var currentTV: TV!
    
    var tvRecord: CKRecord!
    
    let database = CKContainer(identifier: "iCloud.com.Rogue.Viewer").publicCloudDatabase

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.isIdleTimerDisabled = true
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.sound,.badge,.alert]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (autorized, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if autorized {
                DispatchQueue.main.async {
                     application.registerForRemoteNotifications()
                    
                    CloudKitManager.shared.saveSubscription(for: GlobalMessage.recordType,ID:CloudKitManager.messageSubscriptionID)
                    
                    CloudKitManager.shared.saveSubscription(for: TV.recordType,ID:CloudKitManager.tvSubscriptionID)
                
                }
            }
        }
        
        
        // MARK: Check if the current TV is already on CK otherwise it Saves the new record
        
        TVModel.doesExist { (exists, error) in
            print("tv \(exists)")
            if !exists{
                TVModel.addTV(withName: UIDevice.current.name, completionHandler: { (record, error) in
                    guard let _ = record,error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    self.currentTV = TV(record: record!)
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: CKNotificationName.tvSet.rawValue)))
                })
            } else {
                TVModel.getTV(withName: UIDevice.current.name, completionHandler: { (TV, Error) in
                    guard let _ = TV, error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    self.currentTV = TV!
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: CKNotificationName.tvSet.rawValue)))
                })
            }
        }
        
        
        
        return true
    }
    
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("registered")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("notification recieved")
        let notificationName: CKNotificationName
        let ckqn = CKQueryNotification(fromRemoteNotificationDictionary: userInfo as! [String:Any])
        switch ckqn.subscriptionID {
        case CloudKitManager.tvSubscriptionID:
            notificationName = .tv
        case CloudKitManager.messageSubscriptionID:
            notificationName = .globalMessages
        default:
            notificationName = .null
        }
        
        
        
        let notification = Notification(name: Notification.Name(rawValue: notificationName.rawValue),
                                        object: self,
                                        userInfo: [CKNotificationName.notification.rawValue:ckqn])
        NotificationCenter.default.post(notification)
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        playVideo()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        playVideo()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
       CloudKitManager.shared.removeSubscriptions()
       currentTV.isOn = false
    }

    // MARK: Private function
    
    private func playVideo(){
        if let boardViewController = window?.rootViewController as? BoardViewController {
            boardViewController.player.play()
        }
    }
    

}

