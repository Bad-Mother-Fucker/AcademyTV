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

    
    
   static func saveSubscription(for type: String, ID: String) {
        
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
            predicate = NSPredicate(format: "name == %@ ", UIDevice.current.name)
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
            guard subscription != nil, error == nil else {
                print(error!.localizedDescription)
                let err = error as? CKError
                if err?.code ==  CKError.Code.serverRejectedRequest {
                    print("subscription already extists")
                }
                return
            }
            debugPrint ("subscription \(subscription!.subscriptionID) saved")
        }
    }
    
    
    //    Deletes all the subscriptions, use it during times we don't want to listen for push notifications
    
    
    
    
    static func removeSubscriptions() {
        
        CKKeys.database.delete(withSubscriptionID: CKKeys.messageSubscriptionKey) { (_, error) in
            guard error == nil else {
                debugPrint(error!.localizedDescription)
                return
            }
            
        }
        
        CKKeys.database.delete(withSubscriptionID: CKKeys.tvSubscriptionKey) { (_, error) in
            guard error == nil else {
                debugPrint(error!.localizedDescription)
                return
            }
        }
        
        CKKeys.database.delete(withSubscriptionID: CKKeys.serviceSubscriptionKey) { (_, error) in
            guard error == nil else {
                debugPrint(error!.localizedDescription)
                return
            }
        }
    }
    
    

    /**
     ## postTickerMessage(_:onTvNamed:)
     
     
     - Parameters:
     - text, tvName
     
     - SeeAlso: postTickerMessage(_:onTvGroup:),removeTickerMessage(fromTvsIn:),removeTickerMessage(fromTVNamed:)

     - Note: Use this method to post a ticker message on a single TV with name equals to the parameter TvName
     
     - Version: 1.0
     
     - Author: @Micheledes
     */
   
    
    static func postTickerMessage(_ text: String, onTvNamed name: String) {
        TVModel.getTV(withName: name) { (tv, error) in
            guard tv != nil, error == nil else {
                print(error!.localizedDescription)
                return
            }
            tv!.tickerMsg = text
            UsageStatisticsModel.addTickerMessage(length: text.count)
        }
    }
    
    
    /**
     ## postTickerMessage(_:onTvGroup:)
     
     
     - Parameters:
     - text, tvGroup
     
     - SeeAlso: postTickerMessage(_:onTvNamed:),removeTickerMessage(fromTvsIn:),removeTickerMessage(fromTVNamed:)
     
     - Note: Use this method to post a ticker message on a group of tvs with name equals to the parameter TvName
     
     - Version: 1.0
     
     - Author: @Micheledes
     */
    
    
    
    static func postTickerMessage(_ text: String, onTvGroup group: TVGroup) {
        TVModel.getTvs(ofGroup: group) { (tvs, error) in
            guard tvs != nil, error == nil else {
                print(error!.localizedDescription)
                return
            }
            tvs!.forEach({ (tv) in
                tv.tickerMsg = text
            })
            UsageStatisticsModel.addTickerMessage(length: text.count)
        }
    }
    
    
    /**
     ## removeTickerMessage(fromTvsIn:)
     
     - Parameters:
     - tvGroup
     
     - SeeAlso: removeTickerMessage(fromTVNamed:), postTickerMessage(_:onTvGroup:), postTickerMessage(_:onTvNamed:)
     
     - Note: removes any ticker message from all the tvs in the given tv group
     
     - Version: 1.0
     
     - Author: @Micheledes
     */
    
    static func removeTickerMessage(fromTvsIn tvGroup: TVGroup) {
        TVModel.getTvs(ofGroup: tvGroup) { (tvs, error) in
            guard tvs != nil, error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            let records = tvs!.map({ (tv) -> CKRecord in
                tv.record.setValue(nil, forKey: TV.keys.ticker)
                return tv.record
            })
            
            let op = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
            
        }
    }
    
    
    
    /**
     ## removeTickerMessage(fromTVNamed:)
     
     - Parameters:
     - tvGroup
     
     - SeeAlso: removeTickerMessage(fromTvsIn:), postTickerMessage(_:onTvGroup:), postTickerMessage(_:onTvNamed:)
     
     - Note: removes any ticker message from all the tvs in the given tv group
     
     - Version: 1.0
     
     - Author: @Micheledes
     */

    static func removeTickerMessage(fromTVNamed name: String) {
        TVModel.getTV(withName: name) { (tv, error) in
            guard tv != nil, error == nil else {
                print(error!.localizedDescription)
                return
            }
            tv!.record.setValue(nil, forKey: TV.keys.ticker)
            let op = CKModifyRecordsOperation(recordsToSave: [tv!.record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    /**
     ## isThereAMessage(onTV:)
     
     - Parameters:
     - tv

     - Return: Bool

     - Note: Used to check if there is or not a ticker message currently airing on the given tv
     
     - Version: 1.0
     
     - Author: @Micheledes
     */
    
    static func isThereAMessage(onTV tv: TV) -> Bool {
        return tv.tickerMsg != "" 
    }
    
    
    
    
    /**
     ## getAiringTickers(in:)
     
     - Parameters:
     - TV group

     - Return: [(String,String)]
     
     - Note: This method gives all the currently airing ticker messages and their respective tvs.
     
     - Version: 1.0
     
     - Author: @Micheledes
     */

    static func getAiringTickers(in group: TVGroup) -> [(String, String)] {
        let sem = DispatchSemaphore(value: 0)
        var tickers: [(message: String, tvName: String)] = []
        TVModel.getTvs(ofGroup: group) {(tvs, error) in
            guard tvs != nil, error == nil else {
                print(error!.localizedDescription)
                return
            }
            
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
            guard tvs != nil, error == nil else {
                print(error!.localizedDescription)
                return
            }
            
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
    
    static func isThereAKeynote(on tv: TV) -> Bool {
        return tv.keynote != nil
    }
    
    
    /**
     ## remove(globalMessage:)
     
     - Parameters:
     - Global Message

     - SeeAlso: postMessage(title:, subtitle:, location:, description:, URL:,timeToLive:), getAllGlobalMessages(completionHandler:)

     - Note: Use this method to remove the given global message from the currently airing ones
     
     - Version: 1.0
     
     - Author: @Micheledes
     */
    
    static func remove(globalMessage: GlobalMessage) {
        GlobalMessageModel.delete(record: globalMessage.record)
    }
    
    
    
//    Fetches all global messages from the CK database
    
    
    /**
     ## getAllGlobalMessages(completionHandler:)
     
     - Parameters:
     - completion Handler
     
     - Throws: CKQueryException.ConnectionTimedOut
     
     - Return: [GlobalMessage]
  
     - SeeAlso: postMessage(title:, subtitle:, location:, description:, URL:,timeToLive:), remove(globalMessage:)
     
     - Note: Returns all currently airing global messages
     
     - Version: 1.0
     
     - Author: @Micheledes
     */
    
    static func getAllGlobalMessages(completionHandler: @escaping () -> Void) throws -> [GlobalMessage] {
        var mess: [GlobalMessage] = []
        let sem = DispatchSemaphore(value: 0)
        GlobalMessageModel.getAllMessages { (messages, error) in
            guard messages != nil, error == nil else {
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
    
    
    /**
     ## getAllTVs(from:)
     
     - Parameters:
     - tvGroup
   
     - Throws: CKQueryException.connectionTimedOut
     
     - Return: [TV]
     
     - Note: returns all tvs contained in the given group
     
     - Version: 1.0
     
     - Author: @Micheledes
     */
    
    static func getAllTVs(from group: TVGroup) throws -> [TV] {
        var tvVector: [TV] = []
        let sem = DispatchSemaphore(value: 0)
        
        TVModel.getTvs(ofGroup: group) { (tvs, error) in
            guard tvs != nil, error == nil else {
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
    
    
    /**
     ## postMessage(title: subtitle: location: description: URL: timeToLive:)
     
     - Parameters:
     - title, subtitle, location, description, URL, timeToLive
     
     - SeeAlso: remove(message:)
     
     - Note: Airs a new global message with the given parameters
     
     - Version: 1.0
     
     - Author: @Micheledes
     */
    
    static func postMessage(title: String, subtitle: String, location: String?, date: (String?, String?), description: String?, URL: URL?, timeToLive: TimeInterval) {
    GlobalMessageModel.postMessage(title: title, subtitle: subtitle, location: location, date: date, description: description, URL: URL, timeToLive: timeToLive) { (_, error) -> Void in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
        var link: Bool = false
        var hasLocation: Bool = false
        var hasDate: Bool = false
        
        
        if URL != nil {
            link = true
        }
        
        if location != nil {
            hasLocation = true
        }
        
        if date.0 != nil {
            hasDate = true
        }
        
        UsageStatisticsModel.addGlobalMessage(length: description?.count ?? 0, link: link, location: hasLocation, date: hasDate)
    }
    

//    Post a keynote in Png or Jpg format on a given TV (iOS)
    
    /**
     ## postKeynote(_:ofType:onTVNamed:)
     
     - Parameters:
     - keyonte, image file type, tv name
     
     - SeeAlso:  postKeynote(_:ofType:onTVsOfGroup:), removeKeynote(FromTV:)
 
     - Note: This method allows you to post an array of images as a keynote on the tv with the given tv name
     
     - Version: 1.0
     
     - Author: @Micheledes
     */
    
    
   static func postKeynote(_ keynote: [UIImage], ofType imageType: ImageFileType?, onTVNamed name: String) {
        TVModel.getTV(withName: name) { (TV, _) -> Void in
            guard TV != nil else { return }
            TV!.set(keynote: keynote, imageType: imageType ?? .PNG)
        }
        UsageStatisticsModel.addKeynote(length: keynote.count)
    }
    
    
    
    /**
     ## postKeynoteData(_:ofType:onTVNamed:)
     
     - Parameters:
     - data: The images in Data format
     - imageFileType: (JPG or PNG)
     - tvName:  the name of the tv you want to show the keynote on
    
     - SeeAlso: postKeynoteData(_:ofType:onTVsOfGroup:)
 
     - Requires: The images has to be in Data format
     
     - Note: This method is useful when we have to post images from the share extension, and they have to be in data format
     
     - Version: 1.0
     
     - Author: @Micheledes
     */

    static func postKeynoteData(_ data: [Data], ofType type: ImageFileType?, onTVNamed name: String) {
        let keynote = data.map { (imgData) -> UIImage in
            return UIImage(data: imgData) ?? UIImage()
        }
        
        TVModel.getTV(withName: name) { (TV, _) -> Void in
            guard TV != nil else { return }
            TV!.set(keynote: keynote, imageType: type ?? .PNG)
        }
        UsageStatisticsModel.addKeynote(length: data.count)
    }
    
    
    
    static func postKeynoteData(_ data: [Data], ofType imageType: ImageFileType?, onTVsOfGroup group: TVGroup) {
        let keynote = data.map { (imgData) -> UIImage in
            return UIImage(data: imgData) ?? UIImage()
        }
        
        TVModel.getTvs(ofGroup: group) { (tvs, _) in
            guard tvs != nil else { return }
            for tv in tvs! {
                tv.set(keynote: keynote, imageType: imageType ?? .PNG)
            }
        }
        UsageStatisticsModel.addKeynote(length: data.count)
    }
    
//    Post a keynote in Png or Jpg format on a given group of TV (iOS)
    
    /**
     ## postKeynote(_:ofType:onTVsOfGroup:)
     
     - Parameters:
     - keyonte, image file type, tv name
     
     - SeeAlso: postKeynote(_:ofType:onTVNamed:), removeKeynote(FromTV:)
     
     - Note: This method allows you to post an array of images as a keynote on the tvs contained in the given group
     
     - Version: 1.0
     
     - Author: @Micheledes
     */
   static func postKeynote(_ keynote: [UIImage], ofType imageType: ImageFileType?, onTVsOfGroup group: TVGroup) {
        TVModel.getTvs(ofGroup: group) { (tvs, _) in
            guard tvs != nil else { return }
            for tv in tvs! {
                tv.set(keynote: keynote, imageType: imageType ?? .PNG)
            }
        }
        UsageStatisticsModel.addKeynote(length: keynote.count)
    }
    

    
//  Removes keynote from a given TV (iOS)
    
    /**
     ## removeKeynote(FromTV:)
     
     - Parameters:
     - tv name
     
     - SeeAlso:  postKeynote(_:ofType:onTVNamed:),postKeynote(_:ofType:onTVsOfGroup:)
     
     - Note: remove the images posted as keynote from the tv with the given name
     
     - Version: 1.0
     
     - Author: @Micheledes
     */
    
   static func removeKeynote(FromTV name: String) {
        TVModel.getTV(withName: name) { (tv, _) in
            guard let tv = tv else { return } //TODO: Add error handling
            tv.removeKeynote()
        }
    }
    
//  Removes keynote from a given TV group
    
    /**
     ## removeKeynote(FromTVGroup:)
     
     - Parameters:
     - tv group
     
     - SeeAlso:  postKeynote(_:ofType:onTVNamed:),postKeynote(_:ofType:onTVsOfGroup:),removeKeynote(FromTV:)
     
     - Note: remove the images posted as keynote from the all the tvs contained in the given group
     
     - Version: 1.0
     
     - Author: @Micheledes
     */
    
   static func removeKeynote(fromTVGroup g: TVGroup) {
        TVModel.getTvs(ofGroup: g) { (tvs, _) in
            guard let tvs = tvs else { return }
            for tv in tvs {
                print("removing keynote from \(tv.name)")
                tv.removeKeynote() //Add error handling
            }
        }
    }
}



// MARK: - Custom Types and Protocols

/**
 ## CloudStored
 
 
 - Note: The protocol adopted by every data model stored in cloudkit
 
 - Version: 1.0
 
 - Author: @Micheledes
 */

protocol CloudStored {
    var record: CKRecord { get set }
    static var recordType: String { get }
    init(record: CKRecord)
}

/**
 ## CKQueryException
 
 - Parameters:
 - connectionTimedOut: Thrown when a query takes too long to be executed
 - recordNotFound: Thrown when a requested record is not found in the database
 
 - Note: Enum containing the custom exceptions
 
 - Version: 1.0
 
 - Author: @Micheledes
 */


enum CKQueryException: Error {
    case connectionTimedOut(String)
    case recordNotFound(String)
}

/**
 ## CKNotificationName
 
 - Note: Enum containing the notification names used by the notification center
 
 - Version: 1.0
 
 - Author: @Micheledes
 */

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

/**
 ## CKKeys
 
 - Note: Enum containing the subscription keys for cloudkit
 
 - Version: 1.0
 
 - Author: @Micheledes
 */

enum CKKeys {
    
    static let database = CKContainer(identifier: "iCloud.com.TeamRogue.Viewer").publicCloudDatabase
    static let messageSubscriptionKey = "CKMessageSubscription"
    static let tvSubscriptionKey = "CKTVSubscription"
    static let serviceSubscriptionKey = "CKServiceMessageSubscription"
}

protocol ATVViewDelegate {
    func show(keynote: [UIImage])
    func hideKeynote()
    func show(ticker: String)
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
