//
//  CloudKitManager.swift
//  Viewer
//
//  Created by Michele De Sena on 10/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class CloudKitManager {
    
    // MARK: - Singleton Implementation
    static var shared = CloudKitManager()
    private init(){}

    
    // MARK: - Private Variables
    static let database = CKContainer(identifier: "iCloud.com.TeamRogue.Viewer").publicCloudDatabase
    
    
    static let messageSubscriptionID = "CKMessageSubscription"
    static let tvSubscriptionID = "CKTVSubscription"
    static let subscriptionSavedKey = "ckSubscriptionSaved"

    // MARK: - Public implementation
   
    
    func removeSubscriptions() {
        CloudKitManager.database.delete(withSubscriptionID: CloudKitManager.messageSubscriptionID) { (subscriptionID, error) in
            //  TODO: Error handling
        }
        CloudKitManager.database.delete(withSubscriptionID: CloudKitManager.tvSubscriptionID) { (subscriptionID, error) in
            //  TODO: Error handling
        }
    }
    
    
    
    func saveSubscription(for type: String, ID:String) {
        
        // If you wanted to have a subscription fire only for particular
        // records you can specify a more interesting NSPredicate here.
        //
        var predicate = NSPredicate(value: true)
        var options: CKQuerySubscription.Options = [.firesOnRecordCreation, .firesOnRecordDeletion, .firesOnRecordUpdate]
        switch ID {
        case CloudKitManager.messageSubscriptionID:
            break
            
        case CloudKitManager.tvSubscriptionID:
            options = [.firesOnRecordUpdate]
            predicate = NSPredicate(format: "name == %@ ",UIDevice.current.name )
        default:
            break
        }
        
        let subscription = CKQuerySubscription(recordType: type,
                                               predicate: predicate,
                                               subscriptionID: ID,
                                               options: options)
        
        
       
        subscription.notificationInfo = CKSubscription.NotificationInfo()

        CloudKitManager.database.save(subscription) { (subscription, error) in
            guard let _ = subscription, error == nil else {
                print(error!.localizedDescription)
                return
            }
            print ("subscription \(subscription!.subscriptionID) saved")
        }
    }
    
    func getAllGlobalMessages() throws -> [GlobalMessage]  {
        var mess: [GlobalMessage] = []
        let sem = DispatchSemaphore(value: 0)
        GlobalMessageModel.getAllMessages { (messages, error) in
            guard let _ = messages, error == nil else {
                debugPrint(error!.localizedDescription)
                return
            }
            mess = messages!
            sem.signal()
        }
        if sem.wait(timeout: .distantFuture) == .timedOut {
            throw CKQueryException.connectionTimedOut("Request Timed Out, check your internet connection")
        }
        return mess
    }
    
    func getAllTVs(byGroup g:TVGroup) throws -> [TV] {
        var tvVector: [TV] = []
        let sem = DispatchSemaphore(value: 0)
        TVModel.getTvs(ofGroup: g) { (tvs, error) in
            guard let _ = tvs, error == nil else {
                debugPrint(error!.localizedDescription)
                return
            }
            tvVector = tvs!
            sem.signal()
        }
        if sem.wait(timeout: .distantFuture) == .timedOut {
            throw CKQueryException.connectionTimedOut("Request Timed Out, check your internet connection")
        }
        return tvVector
    }

    func postMessage(title:String , subtitle: String, location: String?, description: String?, URL: URL?,timeToLive:TimeInterval ) {
        GlobalMessageModel.postMessage(title:title , subtitle: subtitle, location: location, description: description, URL: URL,timeToLive: timeToLive) { (record, error) -> Void in
            if let _ = error {
                print(error!.localizedDescription)
            }
        }
    }
    
    func postKeynote(_ keynote:[UIImage],withImageType imageType: ImageFileType?,onTVNamed name: String) {
        TVModel.getTV(withName: name) { (TV, error) -> Void in
            guard let _ = TV else {return }
            TV!.set(keynote: keynote, imageType: imageType ?? .PNG)
        }
    }
    
    func postKeynoteData(_ data: [Data], ofType type: ImageFileType?, onTVNamed name: String) {
        TVModel.getTV(withName: name) { (TV, error) -> Void in
            guard let _ = TV else {return }
            TV!.setKeynoteData(data, ofType: type ?? .PNG)
        }
    }
    
    func postKeynote(_ keynote: [UIImage],withImageType imageType:ImageFileType?, onTVsOfGroup group: TVGroup) {
        TVModel.getTvs(ofGroup: group) { (tvs, error) in
            guard let _ = tvs else {return}
            for tv in tvs! {
                tv.set(keynote: keynote, imageType: imageType ?? .PNG)
            }
        }
    
    }
    
    func postKeynoteData(_ data: [Data], ofType type: ImageFileType?, onTVsOfGroup group: TVGroup) {
        TVModel.getTvs(ofGroup: group) { (tvs, error) in
            guard let _ = tvs else {return}
            for tv in tvs! {
                tv.setKeynoteData(data, ofType: type ?? .PNG)
            }
        }
    }
    
    func removeKeynote(FromTV name:String) {
        TVModel.getTV(withName: name) { (tv, error) in
            guard let tv = tv else {return} //TODO: Add error handling
            tv.removeKeynote()
        }
    }
    
    func removeKeynote(fromTVGroup g: TVGroup) {
        TVModel.getTvs(ofGroup: g) { (tvs, error) in
            guard let tvs = tvs else {return}
            for tv in tvs {
                tv.removeKeynote() //Add error handling
            }
        }
    }
    
   
    
    
}

protocol CloudStored {
    var record:CKRecord { get set }
    static var recordType: String { get }
    init(record: CKRecord)
}


enum CKQueryException:Error {
    case connectionTimedOut(String)
    case recordNotFound(String)
}

enum CKNotificationName: String {
    case globalMessages = "global messages notification"
    case tv = "tv notification"
    case null = ""
    case notification = "notification"
    case tvSet = "current tv set"
}

protocol ATVKeynoteDelegate {
    func show(keynote:[UIImage])
    func hideKeynote()
}
