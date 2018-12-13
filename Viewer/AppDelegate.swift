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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.isIdleTimerDisabled = true
        
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
                    CKController.saveSubscription(for: GlobalMessage.recordType,ID:CKKeys.messageSubscriptionKey)
                    CKController.saveSubscription(for: ServiceMessage.recordType, ID: CKKeys.serviceSubscriptionKey)
                    CKController.saveSubscription(for: TV.recordType,ID:CKKeys.tvSubscriptionKey)
                
                }
            }
        }
        
        
        
        // MARK: Check the existence of a ServiceMessage
        
        ServiceMessageModel.isThereAMessage { (isThere,message,error)  in
            if isThere {
                ServiceMessage.record = message!
            } else {
                ServiceMessage.record = CKRecord(recordType: ServiceMessage.recordType)
                ServiceMessage.record.setValue("", forKey: ServiceMessage.keys.text)
                ServiceMessage.record.setValue(0, forKey: ServiceMessage.keys.timer)
                
                CKKeys.database.save(ServiceMessage.record, completionHandler: { (record, error) in
                    guard error == nil else {
                        print(error!.localizedDescription)
                       
                        return
                    }
                })

            }
        }
        
        
        // MARK: Check if the current TV is already on CK otherwise it Saves the new record
        
        TVModel.doesExist { (exists, error) in
            debugPrint("tv \(exists)")
            
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
   
        if UIDevice.current.name == "Lab-04-05"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let glassView = storyboard.instantiateViewController(withIdentifier: "GlassOfficeViewController")
            self.window?.rootViewController = glassView
        }
        
        return true
    }
    
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        Save device token as TV property
        
        print("registered for remote notifications")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("notification recieved")
        let notificationName: CKNotificationName
        let ckqn = CKQueryNotification(fromRemoteNotificationDictionary: userInfo as! [String:Any])
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
//       CKController.removeSubscriptions()
       currentTV.isOn = false
    }

    // MARK: Private function
    
    private func playVideo(){
        if let boardViewController = window?.rootViewController as? BoardViewController {
            boardViewController.videoManager.playVideo()
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("app in background")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("notification recieved")
        print(notification.request.content)
        completionHandler(.badge)
    }
}
