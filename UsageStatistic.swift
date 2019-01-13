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
 
 - Todo: Compleate the logic.
 
 - Version: 1.0
 
 - Author: @GianlucaOrpello
 */
class UsageStatistics {
    
    /**
     ## CloudKit Record
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var record: CKRecord!
    
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
                       numberGMcompleate: "numberGMcompleate")
    
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
        get{
            return record.object(forKey: UsageStatistics.keys.numberTicker) as! Int
        }
        set{
            let currentValue = record.object(forKey: UsageStatistics.keys.numberTicker) as! Int
            record.setValue(currentValue + newValue, forKey: UsageStatistics.keys.numberTicker)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    /**
     ## Set the number of the Keynote posted
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var numberOfKeynote: Int {
        get{
            return record.object(forKey: UsageStatistics.keys.numberKeynote) as! Int
        }
        set{
            let currentValue = record.object(forKey: UsageStatistics.keys.numberKeynote) as! Int
            record.setValue(currentValue + newValue, forKey: UsageStatistics.keys.numberKeynote)
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
        get{
            return record.object(forKey: UsageStatistics.keys.numberGlobalMessage) as! Int
        }
        set{
            let currentValue = record.object(forKey: UsageStatistics.keys.numberGlobalMessage) as! Int
            record.setValue(currentValue + newValue, forKey: UsageStatistics.keys.numberGlobalMessage)
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
        get{
            return record.object(forKey: UsageStatistics.keys.numberGMLink) as! Int
        }
        set{
            let currentValue = record.object(forKey: UsageStatistics.keys.numberGMLink) as! Int
            record.setValue(currentValue + newValue, forKey: UsageStatistics.keys.numberGMLink)
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
            return record.object(forKey: UsageStatistics.keys.numberGMlocation) as! Int
        }
        set{
            let currentValue = record.object(forKey: UsageStatistics.keys.numberGMlocation) as! Int
            record.setValue(currentValue + newValue, forKey: UsageStatistics.keys.numberGMlocation)
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
        get{
            return record.object(forKey: UsageStatistics.keys.numberGMDate) as! Int
        }
        set{
            let currentValue = record.object(forKey: UsageStatistics.keys.numberGMDate) as! Int
            record.setValue(currentValue + newValue, forKey: UsageStatistics.keys.numberGMDate)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    /**
     ## Set the number of Global Message compleate posted
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var numberOfGlobalMessageCompleate: Int {
        get{
            return record.object(forKey: UsageStatistics.keys.numberGMcompleate) as! Int
        }
        set{
            let currentValue = record.object(forKey: UsageStatistics.keys.numberGMcompleate) as! Int
            record.setValue(currentValue + newValue, forKey: UsageStatistics.keys.numberGMcompleate)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    
}
