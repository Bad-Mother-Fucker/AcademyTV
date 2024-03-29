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
    static func saveSubscription(for type: String, ID: String, device: VWDeviceType) {
        
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
            switch device {
            case .TVOSDevice:
                predicate = NSPredicate(format: "name == %@ ", UIDevice.current.name)
            case .iOSDevice:
                predicate = NSPredicate(value: true)
            }
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
                    debugPrint("subscription already extists")
                }
                return
            }
            debugPrint("subscription \(subscription!.subscriptionID) saved")
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
                print(error?.localizedDescription as Any)
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
                print(error?.localizedDescription)
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
            let keynote = UIImage(data: imgData) ?? UIImage()
            return keynote
        }
        
        TVModel.getTV(withName: name) { (TV, _) -> Void in
            guard TV != nil else { return }
            TV!.set(keynote: keynote, imageType: type ?? .PNG)
        }
        UsageStatisticsModel.addKeynote(length: data.count)
    }

    static func postKeynoteData(_ data: [Data], ofType imageType: ImageFileType?, onTVsOfGroup group: TVGroup) {
        let keynote = data.map { (imgData) -> UIImage in
            let keynote = UIImage(data: imgData) ?? UIImage()
            return keynote

        }
        
        TVModel.getTvs(ofGroup: group) { (tvs, _) in
            guard tvs != nil else { return }
            for tv in tvs! {
                tv.set(keynote: keynote, imageType: imageType ?? .PNG)
            }
        }
        UsageStatisticsModel.addKeynote(length: data.count)
    }

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
