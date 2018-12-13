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
    
    @IBOutlet weak var globalMessageView: GlobalMessageView!
    
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
        videoManager =  VideoManger(onLayer: self.view.layer, videos: videosURL)
        videoManager.playVideo()

        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "serviceMessageSet"), object: nil, queue: .main) { (_) in
            self.serviceMessageLabel.text = ServiceMessage.text
            if ServiceMessage.text != "" {
                self.serviceMessageBlurView.fadeIn()
                self.serviceMessageLabel.fadeIn()
                
            }else {
                self.serviceMessageBlurView.fadeOut()
                self.serviceMessageLabel.fadeOut()
            }
            
            
        }
        
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: CKNotificationName.tvSet.rawValue), object: nil, queue: .main) { _ in
            self.currentTV = (UIApplication.shared.delegate as! AppDelegate).currentTV
            self.currentTV.keynoteDelegate = self
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




extension BoardViewController: ATVKeynoteViewDelegate {
    func show(keynote: [UIImage]) {
//      Perform UI Keynote  Showing
        setKeynoteFrame()
        keynoteBlurVIew.fadeIn()
        keynoteView.fadeIn()
        
       
        var page = 0
        
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { (timer) in
            self.keynoteView.image = keynote[nextPage()]
        }
        
        func nextPage() -> Int {
            let index: Int
            if page >= 0 && page < keynote.count {
                index = page
                page = page + 1
                return index
            }else {
                page = 0
                return nextPage()
            }
        }

    }
    
    func hideKeynote() {
        //        Perform UI Keynote hiding
        keynoteView.fadeOut()
        keynoteBlurVIew.fadeOut()
        setNormalFrame()
        
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



