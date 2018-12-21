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

class BoardViewController: TVViewController {
    var keynoteTimer: Timer!
    var keynote: [UIImage] = []
    var page = 0
    
    @IBOutlet weak var keynoteBlurVIew: UIVisualEffectView! {
        didSet {
            keynoteBlurVIew.isHidden = true
            keynoteBlurVIew.layer.cornerRadius = 15
            keynoteBlurVIew.clipsToBounds = true
        }
    }
    
    
    @IBOutlet weak var globalMessageBlurEffect: UIVisualEffectView!{
        didSet{
            globalMessageBlurEffect.layer.cornerRadius = 15
            globalMessageBlurEffect.contentView.layer.cornerRadius = 15
            globalMessageBlurEffect.clipsToBounds = true
            globalMessageBlurEffect.contentView.clipsToBounds = true
            globalMessageBlurEffect.alpha = 0.8
            globalMessageBlurEffect.autoPinEdge(toSuperviewEdge: .left, withInset:35)
            globalMessageBlurEffect.autoPinEdge(toSuperviewEdge: .top, withInset:30)
        }
    }
    
    @IBOutlet weak var dateBlurEffect: UIVisualEffectView!
    @IBOutlet weak var tvNameBlurEffect: UIVisualEffectView!
    
    @IBOutlet weak var keynoteView: UIImageView! {
        didSet{
            keynoteView.isHidden = true
            keynoteView.layer.cornerRadius = 15
            keynoteView.clipsToBounds = true
        }
    }
    
    
    // MARK: Contextual Label
    @IBOutlet weak var tvNameLabel: UILabel!{
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
    
    @IBOutlet weak var globalMessageView: GlobalMessageView! {
        didSet {
            do {
                globalMessageView.globalMessages = try CKController.getAllGlobalMessages {}
            }catch {
                let alert = UIAlertController(title: "Unable to get messages", message: "It seems that there's no internet connection.Check it and try again", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
                    // TODO: Insert code to try again
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!{
        didSet{
            setDate()
            Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] (timer) in
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
    
    
    @IBOutlet weak var serviceMessageLabel: UILabel! {
        didSet {
            serviceMessageLabel.isHidden = true
            serviceMessageLabel.textColor = .white
            serviceMessageLabel.numberOfLines = 0
            serviceMessageLabel.configureForAutoLayout()
            serviceMessageLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25))
        }
    }
    
    @IBOutlet weak var serviceMessageBlurView: UIVisualEffectView! {
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
    override func viewDidLoad() {
        super.viewDidLoad()
        videoManager =  VideoManager(onLayer: self.view.layer, videos: videosURL)
        videoManager.playVideo()

        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "serviceMessageSet"), object: nil, queue: .main) {[weak self] (_) in
            
            if self!.currentTV.tickerMsg.count > 0 {
               self?.currentTV.viewDelegate?.show(ticker: self!.currentTV.tickerMsg)
            }else {
                self?.currentTV.viewDelegate?.hideTicker()
            }
    
        }
        
        keynoteTimer = Timer.init(timeInterval: 10, repeats: true, block: { (timer) in
            if self.keynote.count > 1 {
                 self.keynoteView.image = self.keynote[self.nextPage(of: self.keynote)]
            }
        })
        
        RunLoop.current.add(keynoteTimer, forMode: .common)
        
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: CKNotificationName.tvSet.rawValue), object: nil, queue: .main) { _ in
            self.currentTV = (UIApplication.shared.delegate as! AppDelegate).currentTV
            self.currentTV.viewDelegate = self
            if let keynote = self.currentTV.keynote {
                
                self.show(keynote: keynote)
            }else {
                
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
            let userinfo = notification.userInfo as! [String:GlobalMessage]
            let msg = userinfo["newMsg"]!
            self.globalMessageView.globalMessages.append(msg)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(CKNotificationName.MessageNotification.delete.rawValue), object: nil, queue: .main) { (notification) in
            let userinfo = notification.userInfo as! [String:CKRecord.ID]
            let recordID = userinfo["recordID"]!
            self.globalMessageView.globalMessages = self.globalMessageView.globalMessages.filter({ (msg) -> Bool in
                return msg.record.recordID != recordID
            })
        }
        
        
        NotificationCenter.default.addObserver(forName: Notification.Name(CKNotificationName.MessageNotification.update.rawValue), object: nil, queue: .main) { (notification) in
            let userinfo = notification.userInfo as! [String:GlobalMessage]
            let newMsg = userinfo["modifiedMsg"]!
            self.globalMessageView.globalMessages = self.globalMessageView.globalMessages.map({ (msg) -> GlobalMessage in
                if msg.record.recordID == newMsg.record.recordID {
                    return newMsg
                }
                return msg
            })
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                videoManager.playVideo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
                videoManager.playVideo()
    }
    
    // MARK: Private Implementation
    
    


    
    private func setDate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, HH:mm"
        self.dateLabel.text = dateFormatter.string(from: date)
    }
    
    private func setNormalFrame() {
        UIView.animate(withDuration: 2) {
           
            self.globalMessageBlurEffect.removeFromSuperview()
            self.view.addSubview(self.globalMessageBlurEffect)
            
            self.globalMessageBlurEffect.constraints.forEach({ (constraint) in
                if constraint.identifier == "dimension"{
                    debugPrint("removing dimension constraint")
                    constraint.autoRemove()
                }
            })
            
            self.globalMessageBlurEffect.autoPinEdge(toSuperviewEdge: .left, withInset:30)
            self.globalMessageBlurEffect.autoPinEdge(toSuperviewEdge: .top, withInset:60)
            self.globalMessageBlurEffect.frame = CGRect(origin: self.globalMessageBlurEffect.frame.origin, size: CGSize(width: 897, height: 550))
            self.globalMessageBlurEffect.autoSetDimensions(to: CGSize(width: 897, height: 550))
            self.globalMessageView.setLayout(type: .normal)
        }
        
    }
    private func setKeynoteFrame() {
        
           UIView.animate(withDuration: 2) {

    
            self.globalMessageBlurEffect.removeFromSuperview()
            self.view.addSubview(self.globalMessageBlurEffect)
            
            self.globalMessageBlurEffect.constraints.forEach({ (constraint) in
                if constraint.identifier == "dimension"{
                    debugPrint("removing dimension constraint")
                    constraint.autoRemove()
                }
            })
            
            
              self.globalMessageBlurEffect.frame = CGRect(origin: self.globalMessageBlurEffect.frame.origin, size: CGSize(width: 465, height: self.keynoteView.frame.height))
            self.globalMessageBlurEffect.autoPinEdge(toSuperviewEdge: .left, withInset:30)
            self.globalMessageBlurEffect.autoSetDimensions(to: CGSize(width: 465, height: 783))
//            self.globalMessageBlurEffect.autoSetDimension(.height, toSize: 783)
          
            self.globalMessageBlurEffect.autoPinEdge(.top, to: .top, of: self.keynoteView)
            self.globalMessageBlurEffect.autoPinEdge(.bottom, to: .bottom, of: self.keynoteView)
            self.globalMessageBlurEffect.autoPinEdge(.right, to: .left, of: self.keynoteView, withOffset: -8)
            self.globalMessageView.setLayout(type: .keynote)
            
        }
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
        setKeynoteFrame()
        keynoteBlurVIew.fadeIn()
        keynoteView.isHidden = false
        keynoteView.alpha = 1
        self.keynote = keynote
        keynoteView.image = keynote.first!
    }
    
    func hideKeynote() {
//        Perform UI Keynote hiding
        
        keynoteBlurVIew.fadeOut()
        keynoteView.isHidden = true
        setNormalFrame()
        self.keynote = []
        
    }
    
    
    private func nextPage(of array: [UIImage]) -> Int {
        guard let image = keynoteView.image else {return 0}
        guard var currentIndex = keynote.index(of: image) else {return 0}
        if currentIndex >= 0 && currentIndex < keynote.count - 1  {
            return currentIndex + 1
        }else {
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



