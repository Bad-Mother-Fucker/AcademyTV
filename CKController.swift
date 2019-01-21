//
//  CKController.swift
//  Viewer
//
//  Created by Michele De Sena on 10/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//
// This class offers an Interface for all of CK features in the application
// all methods are implemented as static given that we don't need any instance of it because it is just an interface

import Foundation
import CloudKit
import UIKit

class CKController {
    
    // MARK: - static methods implementation

    
//    Creates and saves subscriptions to push notifications
    
   static func saveSubscription(for type: String, ID:String) {
        
        var predicate = NSPredicate(value: true)
        var options: CKQuerySubscription.Options = []
//        Sets predicate and options based on the subscription type
        
        switch ID {
//        This subscribes to all messages records for CRUD
        case CKKeys.messageSubscriptionKey:
            options = [.firesOnRecordCreation, .firesOnRecordDeletion, .firesOnRecordUpdate]
//        This subscribes just to updates on the current TV record
        case CKKeys.tvSubscriptionKey:
            options = [.firesOnRecordUpdate]
            predicate = NSPredicate(format: "name == %@ ",UIDevice.current.name)
        case CKKeys.serviceSubscriptionKey:
            options = [.firesOnRecordUpdate]
            
        default:
            break
        }
        
//        Create the subscription object and assings it a vacant notification info
        let subscription = CKQuerySubscription(recordType: type,
                                               predicate: predicate,
                                               subscriptionID: ID,
                                               options: options)
        
        subscription.notificationInfo = CKSubscription.NotificationInfo()
        subscription.notificationInfo?.shouldSendContentAvailable = true
    

        CKKeys.database.save(subscription) { (subscription, error) in
            guard let _ = subscription, error == nil else {
                print(error!.localizedDescription)
                let err = error as! CKError
                if err.code ==  CKError.Code.serverRejectedRequest {
                    print("subscription already extists")
                }
                return
            }
            debugPrint ("subscription \(subscription!.subscriptionID) saved")
        }
    }
    
    
    //    Deletes all the subscriptions, use it during times we don't want to listen for push notifications
    
    static func removeSubscriptions() {
        
        CKKeys.database.delete(withSubscriptionID: CKKeys.messageSubscriptionKey) { (subscriptionID, error) in
            guard error == nil else {
                debugPrint(error!.localizedDescription)
                return
            }
            
        }
        
        CKKeys.database.delete(withSubscriptionID: CKKeys.tvSubscriptionKey) { (subscriptionID, error) in
            guard error == nil else {
                debugPrint(error!.localizedDescription)
                return
            }
        }
        
        CKKeys.database.delete(withSubscriptionID: CKKeys.serviceSubscriptionKey) { (subscriptionID, error) in
            guard error == nil else {
                debugPrint(error!.localizedDescription)
                return
            }
        }
    }
    
//    Fetch service message
    
//    static func getServiceMessage() throws {
//        let sem = DispatchSemaphore(value: 0)
//        ServiceMessageModel.getServiceMessage { (record, error) in
//            guard error == nil else {
//                return
//            }
//            ServiceMessage.record = record!
//            sem.signal()
//        }
//        if sem.wait(timeout: .distantFuture) == .timedOut {
//            throw CKQueryException.connectionTimedOut("could not get service message, request timed out")
//        }
    //    }
    
   
    
    static func postTickerMessage(_ text:String,onTvNamed name: String) {
            TVModel.getTV(withName: name) { (tv, error) in
                guard let _ = tv, error == nil else {print(error!.localizedDescription);return}
                tv!.tickerMsg = text
                let op = CKModifyRecordsOperation(recordsToSave: [tv!.record], recordIDsToDelete: nil)
                op.savePolicy = .changedKeys
                CKKeys.database.add(op)
            }
    }
    
    static func postTickerMessage(_ text:String,onTvGroup group: TVGroup) {
        TVModel.getTvs(ofGroup: group) { (tvs, error) in
            guard let _ = tvs, error == nil else {print(error!.localizedDescription);return}
            tvs!.forEach({ (tv) in
                tv.tickerMsg = text
            })
            
            let records = tvs!.map({ (tv) -> CKRecord in
                return tv.record
            })
            
            let op = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    static func removeTickerMessage(from group: TVGroup) {
        TVModel.getTvs(ofGroup: group) { (tvs, error) in
            guard let _ = tvs, error == nil else {print(error!.localizedDescription);return}
            
            let records = tvs!.map({ (tv) -> CKRecord in
                tv.record.setValue(nil, forKey: TV.keys.ticker)
                return tv.record
            })
            
            let op = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
            
        }
    }

    static func removeTickerMessage(fromTVNamed name: String) {
        TVModel.getTV(withName: name) { (tv, error) in
            guard let _ = tv, error == nil else {print(error!.localizedDescription);return}
            tv!.tickerMsg = ""
            let op = CKModifyRecordsOperation(recordsToSave: [tv!.record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    
    
    static func isThereAMessage(onTV tv:TV)->Bool {
        return tv.tickerMsg != ""
    }
    
    /**
     ## Check if there is a keynote on that screen.
     
     - Parameters:
        - tv: The tv that we have to check.
     
     - Return: Return true if there are some keynote.
     
     - Todo: Check with @Micheledes
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    static func isThereAKeynote(on tv: TV)-> Bool {
        return tv.keynote != nil
    }
    
    static func getAiringTickers(in group: TVGroup) -> [(message: String, tvName: String)] {
        let sem = DispatchSemaphore(value: 0)
        var tickers: [(message: String, tvName: String)] = []
        TVModel.getTvs(ofGroup: group) {(tvs, error) in
            guard let _ = tvs, error == nil else {print(error!.localizedDescription);return}
            
            tvs?.forEach({ (tv) in
                if isThereAMessage(onTV: tv) {
                    tickers.append((message: tv.tickerMsg, tvName: tv.name))
                }
            })
            sem.signal()
        }
        
        if sem.wait(timeout: .distantFuture) == .timedOut {
            print("Ticker request timed out")
        }
        return tickers
    }
    
    /**
     ## Check if there is a keynote on that screen.
     
     - Parameters:
        - group: The tv group that we have to check.
     
     - Return: Return the arrey with the images, if there are some.
     
     - Todo: Check with @Micheledes
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    static func getAiringKeynote(in group: TVGroup) -> [(image: [UIImage]?, tvName: String)] {
        let sem = DispatchSemaphore(value: 0)
        var keynote: [(image: [UIImage]?, tvName: String)] = []
        TVModel.getTvs(ofGroup: group) {(tvs, error) in
            guard let _ = tvs, error == nil else {print(error!.localizedDescription);return}
            
            tvs?.forEach({ (tv) in
                if isThereAKeynote(on: tv) {
                    keynote.append((image: tv.keynote, tvName: tv.name))
                }
            })
            sem.signal()
        }
        
        if sem.wait(timeout: .distantFuture) == .timedOut {
            print("Ticker request timed out")
        }
        return keynote
    }
    
    static func remove(globalMessage: GlobalMessage) {
        GlobalMessageModel.delete(record: globalMessage.record)
    }
    
    
    
//    Fetches all global messages from the CK database
    
    static func getAllGlobalMessages(completionHandler: @escaping ()->Void) throws -> [GlobalMessage]  {
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
        completionHandler()
        return mess
    }
    
    
//  Fetches all TVs from a given group
    
    static func getAllTVs(from group :TVGroup) throws -> [TV] {
        var tvVector: [TV] = []
        let sem = DispatchSemaphore(value: 0)
        
        TVModel.getTvs(ofGroup: group) { (tvs, error) in
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
    
    

//    Posts a message to all TVs (iOS)
    
   static func postMessage(title:String , subtitle: String, location: String?, description: String?, URL: URL?,timeToLive:TimeInterval ) {
        GlobalMessageModel.postMessage(title:title , subtitle: subtitle, location: location, description: description, URL: URL,timeToLive: timeToLive) { (record, error) -> Void in
            if let _ = error {
                print(error!.localizedDescription)
            }
        }
    }
    

//    Post a keynote in Png or Jpg format on a given TV (iOS)
    
   static func postKeynote(_ keynote:[UIImage],ofType imageType: ImageFileType?,onTVNamed name: String) {
        TVModel.getTV(withName: name) { (TV, error) -> Void in
            guard let _ = TV else {return }
            TV!.set(keynote: keynote, imageType: imageType ?? .PNG)
        }
    }
    
   static func postKeynoteData(_ data: [Data], ofType type: ImageFileType?, onTVNamed name: String) {
        TVModel.getTV(withName: name) { (TV, error) -> Void in
            guard let _ = TV else {return }
            TV!.setKeynoteData(data, ofType: type ?? .PNG)
        }
    }
    
    
//    Post a keynote in Png or Jpg format on a given group of TV (iOS)
    
   static func postKeynote(_ keynote: [UIImage],ofType imageType:ImageFileType?, onTVsOfGroup group: TVGroup) {
        TVModel.getTvs(ofGroup: group) { (tvs, error) in
            guard let _ = tvs else {return}
            for tv in tvs! {
                tv.set(keynote: keynote, imageType: imageType ?? .PNG)
            }
        }
    
    }
    
    
   static func postKeynoteData(_ data: [Data], ofType type: ImageFileType?, onTVsOfGroup group: TVGroup) {
        TVModel.getTvs(ofGroup: group) { (tvs, error) in
            guard let _ = tvs else {return}
            tvs!.forEach({ (tv) in
                tv.setKeynoteData(data, ofType: type ?? .PNG)
            })
        }
    }
    
//  Removes keynote from a given TV (iOS)
    
   static func removeKeynote(FromTV name:String) {
        TVModel.getTV(withName: name) { (tv, error) in
            guard let tv = tv else {return} //TODO: Add error handling
            tv.removeKeynote()
        }
    }
    
//  Removes keynote from a given TV group
   static func removeKeynote(fromTVGroup g: TVGroup) {
        TVModel.getTvs(ofGroup: g) { (tvs, error) in
            guard let tvs = tvs else {return}
            for tv in tvs {
                print("removing keynote from \(tv.name)")
                tv.removeKeynote() //Add error handling
            }
        }
    }
}



// MARK: - Custom Types and Protocols

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
    case serviceMessage = "service message notification"
    case null = ""
    case notification = "notification"
    case tvSet = "currentTvSet"
    case serviceMessageSet = "serviceMessageSet"
    
    
    enum MessageNotification: String {
        case create = "msgCreated"
        case delete = "msgDeleted"
        case update = "msgUpdated"
    }
}

enum CKKeys {
    
    static let database = CKContainer(identifier: "iCloud.com.Rogue.Viewer").publicCloudDatabase
    static let messageSubscriptionKey = "CKMessageSubscription"
    static let tvSubscriptionKey = "CKTVSubscription"
    static let serviceSubscriptionKey = "CKServiceMessageSubscription"
    
    
}

protocol ATVViewDelegate {
    func show(keynote:[UIImage])
    func hideKeynote()
    func show(ticker:String)
    func hideTicker()
}

enum TVGroup: String{
    case lab1 = "Lab-01"
    case lab2 = "Lab-02"
    case lab3 = "Lab-03"
    case lab4 = "Lab-04"
    case collab1 = "Collab-01"
    case collab2 = "Collab-02"
    case collab3 = "Collab-03"
    case collab4 = "Collab-04"
    case br1 = "BR-01"
    case br2 = "BR-02"
    case br3 = "BR-03"
    case kitchen = "kitchen"
    case seminar = "seminar"
    case all = "all"
}


