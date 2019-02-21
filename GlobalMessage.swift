//
//  GlobalMessage.swift
//  Viewer
//
//  Created by Gianluca Orpello on 22/10/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import Foundation
import CloudKit

class GlobalMessageModel {
     
    static func getAllMessages(completionHandler: @escaping ([GlobalMessage]?, Error?) -> Void) {
        var messages = [GlobalMessage]()
        let query = CKQuery(recordType: GlobalMessage.recordType, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        CKKeys.database.perform(query, inZoneWith: nil) { (records, error) in
            guard error == nil else {
                print(error.debugDescription)
                print("Error on Getting message")
                return
            }
            records?.forEach({ (record) in
                messages.append(GlobalMessage(record: record))
            })
            completionHandler(messages, error)
        }
    }

    // swiftlint:disable function_parameter_count
    static func postMessage(title: String, subtitle: String, location: String?, date: (day: String?, time: String?)?, description: String?, URL: URL?, timeToLive: TimeInterval?, completionHandler: @escaping (CKRecord?, Error?) -> Void) {
        let msg = GlobalMessage(title: title, subtitle: subtitle, location: location, date: date, description: description, URL: URL, timeToLive: timeToLive)
        CKKeys.database.save(msg.record) { (record, error) in
            completionHandler(record, error)
        }
    }
    
    static func delete(record: CKRecord) {
        CKKeys.database.delete(withRecordID: record.recordID) { (_, error) in
            if error != nil {
                print (error!.localizedDescription)
            }
        }
    }
}

class GlobalMessage: CloudStored {
    
    var record: CKRecord

    static var keys = (title: "title", subtitle: "subtitle", location: "location", description: "description", date: "date", url: "url", timeToLive: "TTL")
    
    static var recordType: String = "GlobalMessages"
    
    required init(record: CKRecord) {
        self.record = record
    }
    let formatter = DateFormatter()
    let timeFormatter = DateFormatter()
   
    //static let voidMessage = GlobalMessage(title: "🖥 AirPlay", subtitle: "", location: nil, date: nil, description: "Wirelessly send what's on your iOS device or computer on this display using AirPlay. To learn more go to apple.com/airplay.", URL: URL(string: "apple.com/airplay"), timeToLive: nil)

    static let voidMessage = GlobalMessage(title: " ", subtitle: "", location: nil, date: nil, description: " ", URL: nil, timeToLive: nil)

    init (title: String, subtitle: String, location: String?, date: (day: String?, time: String?)?, description: String?, URL: URL?, timeToLive: TimeInterval?) {
        
        self.record = CKRecord(recordType: GlobalMessage.recordType)
        record.setValue(title, forKey: GlobalMessage.keys.title)
        record.setValue(subtitle, forKey: GlobalMessage.keys.subtitle)
        
        if location != nil {
            record.setValue(location, forKey: GlobalMessage.keys.location)
        }
        if description != nil {
            record.setValue(description, forKey: GlobalMessage.keys.description)
        }
        if URL != nil {
            record.setValue(URL!.absoluteString, forKey: GlobalMessage.keys.url)
        }
        
        if timeToLive != nil {
            record.setValue(timeToLive, forKey: GlobalMessage.keys.timeToLive)
        }
        
    }
    

//    Use this to set a destruction timer to the message
    var timeToLive: Double? {
        get{
            return record.value(forKey: GlobalMessage.keys.timeToLive) as? Double
        }
        set{
            guard newValue != nil else { return }
            record.setValue(newValue, forKey: GlobalMessage.keys.timeToLive)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
        
    }
    
    var title: String {
        get {
            guard let value = record.object(forKey: GlobalMessage.keys.title) as? String else { return "" }
            return value
        }
        set{
            
            record.setValue(newValue, forKey: GlobalMessage.keys.title)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    var subtitle: String {
        get{
            guard let value = record.object(forKey: GlobalMessage.keys.subtitle) as? String else { return "" }
            return value
        }
        set{
            record.setValue(newValue, forKey: GlobalMessage.keys.subtitle)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    var location: String? {
        get{
            return record.object(forKey: GlobalMessage.keys.location) as? String
        }
        set{
            guard newValue != nil else { return }
            record.setValue(newValue, forKey: GlobalMessage.keys.location)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    var description: String? {
        get {
            return record.object(forKey: GlobalMessage.keys.description) as? String
        }
        set{
            guard newValue != nil else { return }
            record.setValue(newValue, forKey: GlobalMessage.keys.description)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    var creationDate: Date {

        guard let value = record.object(forKey: "createdAt") as? Date else { return Date() }

        return value

    }
    
    var url: URL?{
        get{
            guard let string = record.object(forKey: GlobalMessage.keys.url) as? String else { return nil }
            return URL(string: string)
        }
        set{
            guard newValue != nil else { return }
            record.setValue(newValue!.absoluteString, forKey: GlobalMessage.keys.url)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    var date: (day: String?, time: String?) {
        get{
            guard let date = record.object(forKey: GlobalMessage.keys.date) as? Date else { return (nil, nil) }
            formatter.dateFormat = "dd/MM"
            timeFormatter.dateFormat = "hh:mm"
            return (formatter.string(from: date), timeFormatter.string(from: date))
        }
        set{
            
            guard newValue.day != nil else { return }
            formatter.dateStyle = .short
            formatter.dateFormat = "dd/MM hh:mm"
            let date = "\(newValue.day!) \(newValue.time ?? "")"
            record.setValue(formatter.date(from: date), forKey: GlobalMessage.keys.date)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }   
}
