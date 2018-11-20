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
        let msg = ServiceMessage.shared
        msg.text = message
        msg.timer = timer
        let op = CKModifyRecordsOperation(recordsToSave: [ServiceMessage.shared.record], recordIDsToDelete: nil)
        op.savePolicy = .changedKeys
        CKKeys.database.add(op)
    }
    
    static func removeMessage() {
        CKKeys.database.delete(withRecordID: ServiceMessage.shared.record.recordID) { (recordID, error) in
            guard error == nil else {
                debugPrint(error!.localizedDescription)
                return
            }
            debugPrint("Service Message successfully deleted")
        }
    }
    
    static func getServiceMessage(completionHandler: @escaping (CKRecord?,Error?) -> Void) {
        CKKeys.database.fetch(withRecordID: ServiceMessage.shared.record.recordID) { (record, error) in
            completionHandler(record,error)
        }
    }
    
}


class ServiceMessage: CloudStored {
    
    var record: CKRecord
    static var recordType: String = "ServiceMessage"
    static var keys = (text:"text",timer:"timer")
    
    static var shared = ServiceMessage()
    
    private init() {
        self.record = CKRecord(recordType: ServiceMessage.recordType)
        record.setValue("", forKey: ServiceMessage.keys.text)
        record.setValue("", forKey: ServiceMessage.keys.timer)
        CKKeys.database.save(record) { (record, error) in
            guard error == nil else{
                debugPrint(error!.localizedDescription)
                return
            }
        }
    }
    
    required init(record: CKRecord) {
        self.record = record
    }
    
    var text: String {
        get {
            return record.value(forKey: ServiceMessage.keys.text) as! String
        }
        set {
            record.setValue(newValue, forKey: ServiceMessage.keys.text)
        }
    }
    
    var timer: Double {
        get {
            return record.value(forKey: ServiceMessage.keys.timer) as! Double
        }
        set {
            record.setValue(newValue, forKey: ServiceMessage.keys.timer)
        }
    }
    
}
