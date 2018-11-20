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
        getServiceMessage { (record, error) in
            
            guard let _ = record else {
                completionHandler(false,nil,error)
                return
            }
            
            completionHandler(true,record!,nil)
        }
    }
    
    
}


class ServiceMessage {
    
    static var record: CKRecord!
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
