//
//  UsageStatistic.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 13/01/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//

import Foundation
import CloudKit

/**
 ## Class that rappresent the usage stats
 
 - Todo: Complete the logic.
 
 - Version: 1.0
 
 - Author: @GianlucaOrpello
 */
class UsageStatistics {
    
    static var shared = UsageStatistics()
    
    private init() {
        numberOfKeynote = 0
        numberOfGlobalMessage = 0
        numberOfTickerMessage = 0
        numberOfGlobalMessageComplete = 0
        numberOfGlobalMessageWithDate = 0
        numberOfGlobalMessageWithLink = 0
        numberOfGlobalMessageWithLocation = 0
        totalTickerChars = 0
        totalMessageChars = 0
        totalNumberOfPhotos = 0
    }
    
    /**
     ## CloudKit Record
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var record = CKRecord(recordType: UsageStatistics.recordType)
    
    /**
     ## CloudKit Keys
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    static var keys = (numberTicker: "numberTicker",
                       numberKeynote: "numberKeynote",
                       numberGlobalMessage: "numberGlobalMessage",
                       numberGMLink: "numberGMLink",
                       numberGMDate: "numberGMDate",
                       numberGMlocation: "numberGMlocation",
                       numberGMcomplete: "numberGMcomplete",
                       numberOfPhotos: "totNumPhotos",
                       tickerLength: "totTickerLength",
                       messageLength: "totMessageLength",
                       avgNumPhotos: "avgNumPhotos",
                       avgTickerLength: "avgTickerLength",
                       avgMessageLength: "avgMessageLength"
                       )
    
    /**
     ## CloudKit record name
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    static var recordType: String = "UsageStatistics"
    
    /**
     ## Set the number of the Ticker Message
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var numberOfTickerMessage: Int {
        get {
            return record.object(forKey: UsageStatistics.keys.numberTicker) as? Int ?? 0
        }
        set {
            record.setValue(newValue, forKey: UsageStatistics.keys.numberTicker)
            let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            operation.savePolicy = .changedKeys
            CKKeys.database.add(operation)
        }
    }
    
    /**
     ## Set the number of the Keynote posted
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var numberOfKeynote: Int {
        get {
            return record.object(forKey: UsageStatistics.keys.numberKeynote) as? Int ?? 0
        }
        set {
            record.setValue(newValue, forKey: UsageStatistics.keys.numberKeynote)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    /**
     ## Set the number of Global Message posted
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var numberOfGlobalMessage: Int {
        get {
            return record.object(forKey: UsageStatistics.keys.numberGlobalMessage) as? Int ?? 0
        }
        set {
            record.setValue(newValue, forKey: UsageStatistics.keys.numberGlobalMessage)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    /**
     ## Set the number of Global Message with link posted
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var numberOfGlobalMessageWithLink: Int {
        get {
            return record.object(forKey: UsageStatistics.keys.numberGMLink) as? Int ?? 0
        }
        set {
            record.setValue(newValue, forKey: UsageStatistics.keys.numberGMLink)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    /**
     ## Set the number of Global Message with location posted
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var numberOfGlobalMessageWithLocation: Int {
        get{
            return record.object(forKey: UsageStatistics.keys.numberGMlocation) as? Int ?? 0
        }
        set{
            record.setValue(newValue, forKey: UsageStatistics.keys.numberGMlocation)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    /**
     ## Set the number of Global Message with date posted
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var numberOfGlobalMessageWithDate: Int {
        get {
            return record.object(forKey: UsageStatistics.keys.numberGMDate) as? Int ?? 0
        }
        set {
            record.setValue(newValue, forKey: UsageStatistics.keys.numberGMDate)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    /**
     ## Set the number of Global Message complete posted
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var numberOfGlobalMessageComplete: Int {
        get {
            return record.object(forKey: UsageStatistics.keys.numberGMcomplete) as? Int ?? 0
        }
        set {
            record.setValue(newValue, forKey: UsageStatistics.keys.numberGMcomplete)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    
    
    
    
    var totalNumberOfPhotos: Int {
        get {
            return record.object(forKey: UsageStatistics.keys.numberOfPhotos) as? Int ?? 0
        }
        set {
            record.setValue(newValue, forKey: UsageStatistics.keys.numberOfPhotos)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    var totalTickerChars: Int {
        get {
            return record.object(forKey: UsageStatistics.keys.tickerLength) as? Int ?? 0
        }
        set {
            record.setValue(newValue, forKey: UsageStatistics.keys.tickerLength)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    var totalMessageChars: Int {
        get {
            return record.object(forKey: UsageStatistics.keys.messageLength) as? Int ?? 0
        }
        set {
            record.setValue(newValue, forKey: UsageStatistics.keys.messageLength)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    var averageNumOfPhotos: Double {
        get {
            return record.object(forKey: UsageStatistics.keys.avgNumPhotos) as? Double ?? 0
        }
        set {
            record.setValue(newValue, forKey: UsageStatistics.keys.avgNumPhotos)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    var averageTickerLength: Double {
        get {
            return record.object(forKey: UsageStatistics.keys.avgTickerLength) as? Double ?? 0
        }
        set {
            record.setValue(newValue, forKey: UsageStatistics.keys.avgTickerLength)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    var averageMessageLength: Double {
        get {
            return record.object(forKey: UsageStatistics.keys.avgMessageLength) as? Double ?? 0
        }
        set {
            record.setValue(newValue, forKey: UsageStatistics.keys.avgMessageLength)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
}

class UsageStatisticsModel {

    static func addTickerMessage(length: Int) {
        UsageStatistics.shared.numberOfTickerMessage += 1
        UsageStatistics.shared.totalTickerChars += length
        UsageStatistics.shared.averageTickerLength = Double(UsageStatistics.shared.totalTickerChars / UsageStatistics.shared.numberOfTickerMessage)
    }

    static func addGlobalMessage(length: Int, link: Bool, location: Bool, date: Bool) {
        UsageStatistics.shared.numberOfGlobalMessage += 1
        UsageStatistics.shared.totalMessageChars += length
        if link {
            UsageStatistics.shared.numberOfGlobalMessageWithLink += 1
        }
        
        if location {
            UsageStatistics.shared.numberOfGlobalMessageWithLocation += 1
        }
        
        if date {
            UsageStatistics.shared.numberOfGlobalMessageWithDate += 1
        }
        
        if link && location && date {
            UsageStatistics.shared.numberOfGlobalMessageComplete += 1
        }
        
        UsageStatistics.shared.averageMessageLength = Double(UsageStatistics.shared.totalMessageChars / UsageStatistics.shared.numberOfGlobalMessage)
        
        
    }

    static func addKeynote(length: Int) {
        UsageStatistics.shared.numberOfKeynote += 1
        UsageStatistics.shared.totalNumberOfPhotos += length
        UsageStatistics.shared.averageNumOfPhotos = Double(UsageStatistics.shared.totalNumberOfPhotos / UsageStatistics.shared.numberOfKeynote)
    }
}
