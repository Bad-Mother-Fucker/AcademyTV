//
//  TVViewController.swift
//  Viewer
//
//  Created by Michele De Sena on 19/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit
import CloudKit

class TVViewController: UIViewController {
    var serviceMessage:ServiceMessage?
    var globalMessages = [GlobalMessage](){
        didSet{
            print(globalMessages)
        }
    }

    let appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    var currentTV:TV!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: CKNotificationName.globalMessages.rawValue), object: nil, queue: OperationQueue.main) { (notification) in
            if let ckqn = notification.userInfo?[CKNotificationName.notification.rawValue] as? CKQueryNotification {
                self.handleCKNotification(ckqn)
            }
            debugPrint(self.globalMessages)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(CKNotificationName.tv.rawValue), object: nil, queue: .main) { (notification) in
            if let ckqn = notification.userInfo?[CKNotificationName.notification.rawValue] as? CKQueryNotification {
                self.handleCKNotification(ckqn)
            }
            debugPrint("Tv record edited")
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(CKNotificationName.serviceMessage.rawValue), object: nil, queue: .main) { (notification) in
            if let ckqn = notification.userInfo?[CKNotificationName.notification.rawValue] as? CKQueryNotification {
                self.handleCKNotification(ckqn)
            }
            debugPrint("service message uploaded")
        }
        
    }
    
    private func handleCKNotification(_ ckqn: CKQueryNotification) {
        switch ckqn.subscriptionID {
        case CKKeys.messageSubscriptionKey:
            handleMsgNotification(ckqn)
        case CKKeys.tvSubscriptionKey:
            handleTVNotification(ckqn)
        case CKKeys.serviceSubscriptionKey:
            handleServiceMessageNotification(ckqn)
        default:
            break
            
        }
    }
    
    private func handleServiceMessageNotification(_ ckqn: CKQueryNotification) {
        serviceMessage = try? CKController.getServiceMessage()
    }
    
    private func handleMsgNotification(_ ckqn: CKQueryNotification) {
        guard let recordID = ckqn.recordID else {return}
        
        switch ckqn.queryNotificationReason {
        case .recordCreated:
            CKKeys.database.fetch(withRecordID: recordID) { (record, error) in
                guard let _ = record, error == nil else {
                    if let ckError = error as? CKError {
                        let errorCode = ckError.errorCode
                        print(CKError.Code(rawValue: errorCode).debugDescription)
                    }
                    return
                    
                }
                let msg = GlobalMessage(record: record!)
                DispatchQueue.main.async {
                    self.globalMessages.append(msg)
                }
                
            }
        case .recordDeleted:
            self.globalMessages = self.globalMessages.filter { (msg) -> Bool in
                return msg.record.recordID != recordID
            }
            
        case .recordUpdated:
            CKKeys.database.fetch(withRecordID: recordID) { (record, error) in
                guard let _ = record, error == nil else {return}
                let newMsg = GlobalMessage(record: record!)
                DispatchQueue.main.async {
                    self.globalMessages = self.globalMessages.map { (msg) -> GlobalMessage in
                        if msg.record.recordID == recordID {
                            return newMsg
                        }
                        return msg
                    }
                }
            }
        }
    }
    
    private func handleTVNotification(_ ckqn: CKQueryNotification) {
        guard let recordID = ckqn.recordID else {return}
        
        switch ckqn.queryNotificationReason {
        case .recordCreated:
            break
        case .recordDeleted:
            break
        case .recordUpdated:
            
            CKKeys.database.fetch(withRecordID: recordID) { (record, error) in
                guard let _ = record, error == nil else {return}
                DispatchQueue.main.async {
                    
                    self.appDelegate.currentTV = TV(record:record!)
                    if let keynote = self.appDelegate.currentTV.keynote {
                        self.appDelegate.currentTV.keynoteDelegate?.show(keynote: keynote)
                    } else {
                        self.appDelegate.currentTV.keynoteDelegate?.hideKeynote()
                    }
                }
                
            }
            
        }
    }

}
