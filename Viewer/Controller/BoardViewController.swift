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
import PureLayout

/**
 ## Board View Controller

 The main View Controller of all the Tvs. Here we can manage all the messages and the keynote promps.
 
 - Version: 1.0
 
 - Author: @GianlucaOrpello, @Micheledes
 */
class BoardViewController: TVViewController {
    
    /**
     ## Keynote Timer
     
     - Version: 1.0
     
     - Author: @Micheledes
     */
    var keynoteTimer: Timer!
    
    /**
     ## Keynote Image List
     
     List of image that contains all the keynote page.
     
     - Version: 1.0
     
     - Author: @Micheledes
     */
    var keynote: [UIImage] = []
    
    /**
     ## Page Counter
     
     - Version: 1.0
     
     - Author: @Micheledes
     */
    var page = 0
    
    // MARK: - Outlets
    
    /**
     ## Visual Effect View Keynote
     
     View used for manage the blur effect under the keynote promp.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @IBOutlet private weak var keynoteBlurView: UIVisualEffectView! {
        didSet {
            keynoteBlurView.isHidden = true
            keynoteBlurView.layer.cornerRadius = 15
            keynoteBlurView.clipsToBounds = true
        }
    }
    
    /**
     ## Visual Effect View Message
     
     View used for manage the blur effect under the Global Message promp.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @IBOutlet private weak var globalMessageBlurEffect: UIVisualEffectView!{
        didSet{
            globalMessageBlurEffect.layer.cornerRadius = 15
            globalMessageBlurEffect.contentView.layer.cornerRadius = 15
            globalMessageBlurEffect.clipsToBounds = true
            globalMessageBlurEffect.contentView.clipsToBounds = true
            globalMessageBlurEffect.alpha = 0.8
            globalMessageBlurEffect.autoPinEdge(toSuperviewEdge: .left, withInset: 35)
            globalMessageBlurEffect.autoPinEdge(toSuperviewEdge: .top, withInset: 30)
        }
    }
    
    /**
     ## Visual Effect View Date
     
     View used for manage the blur effect under the Date promp.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @IBOutlet private weak var dateBlurEffect: UIVisualEffectView!
    
    /**
     ## Visual Effect View TvName
     
     View used for manage the blur effect under the Tv Name promp.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @IBOutlet private weak var tvNameBlurEffect: UIVisualEffectView!
    
    /**
     ## Keynote Image View Container
     
     Image view used for display the keynote file converted as an image.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @IBOutlet private weak var keynoteView: UIImageView! {
        didSet{
            keynoteView.isHidden = true
            keynoteView.layer.cornerRadius = 15
            keynoteView.clipsToBounds = true
        }
    }
    
    // MARK: Contextual Label
    
    /**
     ## Tv Name Label
     
     Label used for display the name of the current tv.
     This data are taken from the setting of the current device, be sure that have the correct name.
   
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @IBOutlet private weak var tvNameLabel: UILabel!{
        didSet{
            tvNameLabel.text = UIDevice.current.name
            
            let tvMaskPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 500, height: 85),
                                          byRoundingCorners: [.topLeft, .bottomLeft],
                                          cornerRadii: CGSize(width: 15.0, height: 15.0))
            
            let tvShape = CAShapeLayer()
            tvShape.path = tvMaskPath.cgPath
            tvNameBlurEffect.layer.mask = tvShape
        }
    }
    
    /**
     ## Global Message View Promp.
     
     View used for managing the Global Message Promp.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @IBOutlet private weak var globalMessageView: GlobalMessageView! {
        didSet {
            do {
                globalMessageView.globalMessages = try CKController.getAllGlobalMessages {}
            } catch {
                let alert = UIAlertController(title: "Unable to get messages", message: "It seems that there's no internet connection.Check it and try again", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default) { _ in
                    // TODO: Insert code to try again
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    /**
     ## Date Label
     
     Label used for show the current date.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @IBOutlet private weak var dateLabel: UILabel!{
        didSet{
            setDate()
            Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
                self?.setDate()
            }
            
            let dateMaskPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: dateBlurEffect.frame.width, height: 85),
                                            byRoundingCorners: [.bottomRight, .topRight],
                                            cornerRadii: CGSize(width: 15.0, height: 15.0))
            
            let dateShape = CAShapeLayer()
            dateShape.path = dateMaskPath.cgPath
            dateBlurEffect.layer.mask = dateShape
        }
    }
    
    /**
     ## Service Message Label
     
     Label used for managing the Ticker Message Promp.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @IBOutlet private weak var serviceMessageLabel: UILabel! {
        didSet {
            serviceMessageLabel.isHidden = true
            serviceMessageLabel.textColor = .white
            serviceMessageLabel.numberOfLines = 0
            serviceMessageLabel.configureForAutoLayout()
            serviceMessageLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25))
        }
    }
    
    /**
     ## Visual Effect View Service Message
     
     View used for manage the blur effect under the Ticker View promp.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @IBOutlet private weak var serviceMessageBlurView: UIVisualEffectView! {
        didSet {
            serviceMessageBlurView.isHidden = true
            serviceMessageBlurView.layer.cornerRadius = 15
            serviceMessageBlurView.clipsToBounds = true
            serviceMessageBlurView.configureForAutoLayout()
            serviceMessageBlurView.autoPinEdge(.left,
                                               to: .right,
                                               of: dateBlurEffect,
                                               withOffset: 20)
            
            serviceMessageBlurView.autoPinEdge(.bottom,
                                               to: .bottom,
                                               of: dateBlurEffect)
            
            serviceMessageBlurView.autoMatch(.height,
                                             to: .height,
                                             of: dateBlurEffect)
            
//            serviceMessageBlurView.autoPinEdge(toSuperviewEdge: .right,
//                                               withInset:10,
//                                               relation: .greaterThanOrEqual)
            
        }
    }
    
    // MARK: View Controller Life cycle
    
    /**
     ## View Did Load
     
     * Load the background Video
     * Add all the Observer needed for check the events and notification.
     
     - Todo: Check if we need to remove the observer.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        videoManager = VideoManager(onLayer: self.view.layer, videos: videosURL)
        videoManager.playVideo()
        globalMessageView.layoutView()
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "serviceMessageSet"), object: nil, queue: .main) {[weak self] (_) in
            
            if self!.currentTV.tickerMsg.count > 0 {
               self?.currentTV.viewDelegate?.show(ticker: self!.currentTV.tickerMsg)
            } else {
                self?.currentTV.viewDelegate?.hideTicker()
            }
    
        }
        
        keynoteTimer = Timer.init(timeInterval: 10, repeats: true, block: { _ in
            if self.keynote.count > 1 {
                 self.keynoteView.image = self.keynote[self.nextPage(of: self.keynote)]
            }
        })
        
        RunLoop.current.add(keynoteTimer, forMode: .common)
        
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: CKNotificationName.tvSet.rawValue), object: nil, queue: .main) { _ in
            self.currentTV = (UIApplication.shared.delegate as? AppDelegate)?.currentTV
            self.currentTV.viewDelegate = self
           
            
            if let keynote = self.currentTV.keynote {
                self.show(keynote: keynote)
            } else {
                self.hideKeynote()
            }
            
            
            do {
                self.globalMessageView.globalMessages = try CKController.getAllGlobalMessages(completionHandler: {})
            } catch {
                print(error.localizedDescription)
            }
        }
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { [weak self] _ in
            debugPrint("Video ended")
            self?.videoManager.nextVideo() 
            debugPrint("Playing next video")
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(CKNotificationName.MessageNotification.create.rawValue), object: nil, queue: .main) { (notification) in
            let userinfo = notification.userInfo as? [String: GlobalMessage]
            if let msg = userinfo?["newMsg"] {
                self.globalMessageView.globalMessages.append(msg)
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(CKNotificationName.MessageNotification.delete.rawValue), object: nil, queue: .main) { (notification) in
            let userinfo = notification.userInfo as? [String: CKRecord.ID]
            if let recordID = userinfo?["recordID"] {
                self.globalMessageView.globalMessages = self.globalMessageView.globalMessages.filter({ (msg) -> Bool in
                    return msg.record.recordID != recordID
                })
            }
        }
        
        
        NotificationCenter.default.addObserver(forName: Notification.Name(CKNotificationName.MessageNotification.update.rawValue), object: nil, queue: .main) { (notification) in
            let userinfo = notification.userInfo as? [String: GlobalMessage]
            if let newMsg = userinfo?["modifiedMsg"] {
                self.globalMessageView.globalMessages = self.globalMessageView.globalMessages.map({ (msg) -> GlobalMessage in
                    if msg.record.recordID == newMsg.record.recordID {
                        return newMsg
                    }
                    return msg
                })
            }
        }
        
    }
    
    /**
     ## View Did Appear
     
     On View appear just play the video.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoManager.playVideo()
    }
    
    /**
     ## View Will Appear
     
     On View appear just play the video.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        videoManager.playVideo()
    }
    
    // MARK: Private Implementation
    
    /**
     ## Set the current date
     
     Get the current date and set the label.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    private func setDate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, HH:mm"
        self.dateLabel.text = dateFormatter.string(from: date)
    }
    
}

extension BoardViewController: ATVViewDelegate {
    
    func show(ticker text: String) {
        serviceMessageBlurView.fadeIn()
        serviceMessageLabel.isHidden = false
        self.serviceMessageLabel.text = text
    }
    
    func hideTicker() {
        serviceMessageBlurView.fadeOut()
        self.serviceMessageLabel.text = ""
    }
    
    func show(keynote: [UIImage]) {
//      Perform UI Keynote  Showing
        
        keynoteBlurView.fadeIn()
        keynoteView.isHidden = false
        keynoteView.alpha = 1
        self.keynote = keynote
        keynoteView.image = keynote.first!
    }
    
    func hideKeynote() {
//        Perform UI Keynote hiding
        
        keynoteBlurView.fadeOut()
        keynoteView.isHidden = true
       
        self.keynote = []
        
    }
    
    
    private func nextPage(of array: [UIImage]) -> Int {
        guard let image = keynoteView.image else { return 0 }
        guard var currentIndex = keynote.index(of: image) else { return 0 }
        if currentIndex >= 0 && currentIndex < keynote.count - 1  {
            return currentIndex + 1
        } else {
            currentIndex = 0
            return currentIndex
        }
    }

    
}

extension UIView {
    func fadeIn() {
        self.isHidden = false
        self.alpha = 0
        UIView.animate(withDuration: 1) {
            self.alpha = 1
        }
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 1) {
            self.alpha = 0
        }
    }
}
