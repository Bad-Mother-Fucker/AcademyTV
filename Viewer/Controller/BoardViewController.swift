//
//  BoardViewController.swift
//  Viewer
//
//  Created by Gianluca Orpello on 21/10/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit
import CloudKit
import AVFoundation

class BoardViewController: UIViewController {
    
    var player: AVPlayer!
    var globalMessages = [GlobalMessage](){
        didSet{
            print(globalMessages)
        }
    }
     let appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    var currentTV:TV!
    
    
    @IBOutlet var blurViews: [UIVisualEffectView]!{
        didSet{
            blurViews.forEach { (view) in
                view.layer.cornerRadius = 20
                view.contentView.layer.cornerRadius = 20
                view.clipsToBounds = true
                view.contentView.clipsToBounds = true
                view.alpha = 0.8
            }
        }
    }
    
    // MARK: Contextual Label
    @IBOutlet weak var tvNameLabel: UILabel!{
        didSet{
            tvNameLabel.text = UIDevice.current.name
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!{
        didSet{
            setDate()
            Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] (timer) in
                self?.setDate()
            }
        }
    }
    
    // MARK: View Controller Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        playVideo()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { [weak self] _ in
            self?.player.seek(to: CMTime.zero)
            self?.player.play()
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: CKNotificationName.globalMessages.rawValue), object: nil, queue: OperationQueue.main) { (notification) in
            if let ckqn = notification.userInfo?[CKNotificationName.notification.rawValue] as? CKQueryNotification {
                self.handleCKNotification(ckqn)
            }
            print(self.globalMessages)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: CKNotificationName.tvSet.rawValue), object: nil, queue: .main) { [weak self] _ in
            self?.currentTV = (UIApplication.shared.delegate as! AppDelegate).currentTV
            self?.currentTV.keynoteDelegate = self
        }
        
        
    }
    
   
    
    
    private func handleCKNotification(_ ckqn: CKQueryNotification) {
        switch ckqn.subscriptionID {
        case CloudKitManager.messageSubscriptionID:
            handleMsgNotification(ckqn)
        case CloudKitManager.tvSubscriptionID:
            handleTVNotification(ckqn)
        default:
            break
            
        }
    }
    
    private func handleMsgNotification(_ ckqn: CKQueryNotification) {
        guard let recordID = ckqn.recordID else {return}
        
        switch ckqn.queryNotificationReason {
        case .recordCreated:
            CloudKitManager.database.fetch(withRecordID: recordID) { (record, error) in
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
            CloudKitManager.database.fetch(withRecordID: recordID) { (record, error) in
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
            
            CloudKitManager.database.fetch(withRecordID: recordID) { (record, error) in
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        player.play()
    }
    
    // MARK: Private Implementation
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "Background", ofType:"m4v") else {
            debugPrint("Background.mp4 not found")
            return
        }
        
        player = AVPlayer(url: URL(fileURLWithPath: path))
        player.isMuted = true
        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        layer.zPosition = -1
        layer.frame = self.view.frame
        
        self.view.layer.addSublayer(layer)
        
        player.play()
        
    }
    
    private func setDate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, HH:mm"
        
        self.dateLabel.text = dateFormatter.string(from: date)
    }
   
}

extension BoardViewController: ATVKeynoteDelegate {
    func show(keynote: [UIImage]) {
//        Perform UI Keynote  Showing
    }
    
    func hideKeynote() {
//        Perform UI Keynote hiding
    }
    
    
}
