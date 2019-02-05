//
//  TVViewController.swift
//  Viewer
//
//  Created by Michele De Sena on 19/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit
import CloudKit
import AVFoundation

class TVViewController: UIViewController {
    var globalMessages: [GlobalMessage] = [] {
        didSet{
            print(globalMessages)
        }
    }

    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate

    let assets = [AVAssets.elmo, AVAssets.floridiana, AVAssets.lungomare, AVAssets.uovo]

    var currentTV: TV!
    
    var videosURL: [AVPlayerItem] {
        let items = assets.map { (asset) -> AVPlayerItem in
            let item = AVPlayerItem(asset: asset)
            return item
        }
        return items
    }
    
    var videoManager: VideoManager!
    
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
    
        
    }
    
    private func handleMsgNotification(_ ckqn: CKQueryNotification) {
        guard let recordID = ckqn.recordID else { return }
        
        switch ckqn.queryNotificationReason {
        case .recordCreated:
            CKKeys.database.fetch(withRecordID: recordID) { (record, error) in
                guard record != nil, error == nil else {
                    if let ckError = error as? CKError {
                        let errorCode = ckError.errorCode
                        print(CKError.Code(rawValue: errorCode).debugDescription)
                    }
                    return
                    
                }
                let msg = GlobalMessage(record: record!)
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: CKNotificationName.MessageNotification.create.rawValue), object: self, userInfo: ["newMsg": msg])
                }
                
            }
        case .recordDeleted:
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: CKNotificationName.MessageNotification.delete.rawValue), object: self, userInfo: ["recordID": recordID])
            
        case .recordUpdated:
            CKKeys.database.fetch(withRecordID: recordID) { (record, error) in
                guard record != nil, error == nil else { return }
                let msg = GlobalMessage(record: record!)
                DispatchQueue.main.async {
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: CKNotificationName.MessageNotification.update.rawValue), object: self, userInfo: ["modifiedMsg": msg])
                }
            }
        }
        
    }
    
    private func handleTVNotification(_ ckqn: CKQueryNotification) {
        guard let recordID = ckqn.recordID else { return }
        
        switch ckqn.queryNotificationReason {
        case .recordCreated:
            break
        case .recordDeleted:
            
            break
        case .recordUpdated:
            
            CKKeys.database.fetch(withRecordID: recordID) { (record, error) in
                guard record != nil, error == nil else { return }
                DispatchQueue.main.async {
                    if let delegate = self.appDelegate {
                        delegate.currentTV.record = record!
                        if let keynote = delegate.currentTV.keynote {
                            delegate.currentTV.viewDelegate?.show(keynote: keynote)
                        } else {
                            delegate.currentTV.viewDelegate?.hideKeynote()
                        }
                        if delegate.currentTV.tickerMsg.count > 0 {
                            delegate.currentTV.viewDelegate?.show(ticker: delegate.currentTV.tickerMsg)
                        } else {
                            delegate.currentTV.viewDelegate?.hideTicker()
                        }
                    }
                }
            }
        }
    }
}
