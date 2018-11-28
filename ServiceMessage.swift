//
//  ServiceMessage.swift
//  Viewer
//
//  Created by Michele De Sena on 20/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import Foundation
import CloudKit

class ServiceMessageModel {
    
    static func post(message: String,forSeconds timer: Double,completionHandler: @escaping (CKRecord?,Error?) -> Void) {
        let msg = ServiceMessage.self
        msg.text = message
        msg.timer = timer
        let op = CKModifyRecordsOperation(recordsToSave: [ServiceMessage.record], recordIDsToDelete: nil)
        op.savePolicy = .changedKeys
        CKKeys.database.add(op)
    }
    
    static func removeMessage() {
        CKKeys.database.delete(withRecordID: ServiceMessage.record.recordID) { (recordID, error) in
            guard error == nil else {
                debugPrint(error!.localizedDescription)
                return
            }
            debugPrint("Service Message successfully deleted")
        }
    }
    
    static func getServiceMessage(completionHandler: @escaping (CKRecord?,Error?) -> Void) {
        CKKeys.database.fetch(withRecordID: ServiceMessage.record.recordID) { (record, error) in
            completionHandler(record,error)
        }
    }
    
    static func isThereAMessage(completionHandler: @escaping (Bool,CKRecord?,Error?) -> Void ) {
        
        let query = CKQuery(recordType: ServiceMessage.recordType, predicate: NSPredicate(value: true))
       
        CKKeys.database.perform(query, inZoneWith: nil) { (records, error) in
            guard error == nil,records != nil else {
                print(error.debugDescription)
                print("Error on Getting message")
                return
            }
            if records!.count > 0 {
                completionHandler(true,records!.first,error)
            }else {
                completionHandler(false,nil,CKQueryException.recordNotFound("No service message found"))
            }
            
        }

    }
    
    
}


class ServiceMessage {
    
    static var record: CKRecord! {
        didSet{
            NotificationCenter.default.post(name: Notification.Name("serviceMessageSet"), object: nil)
        }
    }
    static var recordType: String = "ServiceMessage"
    static var keys = (text:"text",timer:"timer")
    
    
    static func set(serviceMessage: CKRecord?) {
        
        guard let _ = serviceMessage else {
            ServiceMessage.record = CKRecord(recordType: ServiceMessage.recordType)
            ServiceMessage.record.setValue("", forKey: ServiceMessage.keys.text)
            ServiceMessage.record.setValue("", forKey: ServiceMessage.keys.timer)
            CKKeys.database.save(ServiceMessage.record!) { (record, error) in
                guard error == nil else{
                    debugPrint(error!.localizedDescription)
                    return
                }
            }
            return
        }
        
        ServiceMessage.record = record!
    }
    
   
    
    static var text: String {
        get {
            return record.value(forKey: ServiceMessage.keys.text) as! String
        }
        set {
            record.setValue(newValue, forKey: ServiceMessage.keys.text)
            NotificationCenter.default.post(name: Notification.Name("serviceMessageSet"), object: nil)
        }
        
    }
    
    static var timer: Double {
        get {
            return record.value(forKey: ServiceMessage.keys.timer) as! Double
        }
        set {
            record.setValue(newValue, forKey: ServiceMessage.keys.timer)
        }
    }
    
}
