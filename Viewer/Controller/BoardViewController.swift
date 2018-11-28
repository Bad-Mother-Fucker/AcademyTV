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

class BoardViewController: TVViewController {
    
    var player: AVPlayer!
    
    var keynoteBlurView: UIVisualEffectView!{
        didSet{
            keynoteBlurView.layer.cornerRadius = 20
            keynoteBlurView.clipsToBounds = true
            keynoteBlurView.contentView.layer.cornerRadius = 20
            keynoteBlurView.contentView.clipsToBounds = true
        }
    }
    @IBOutlet weak var globalMessageBlurEffect: UIVisualEffectView!{
        didSet{
            globalMessageBlurEffect.layer.cornerRadius = 20
            globalMessageBlurEffect.contentView.layer.cornerRadius = 20
            globalMessageBlurEffect.clipsToBounds = true
            globalMessageBlurEffect.contentView.clipsToBounds = true
            globalMessageBlurEffect.alpha = 0.8
        }
    }
    
    @IBOutlet weak var dateBlurEffect: UIVisualEffectView!
    @IBOutlet weak var tvNameBlurEffect: UIVisualEffectView!
    
    @IBOutlet weak var keynoteView: UIImageView! {
        didSet{
            keynoteView.isHidden = true
            keynoteView.layer.cornerRadius = 20
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
            
            let dateMaskPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: (dateLabel.frame.width*3)+5, height: 85),
                                            byRoundingCorners: [.bottomRight, .topRight],
                                            cornerRadii: CGSize(width: 15.0, height: 15.0))
            
            let dateShape = CAShapeLayer()
            dateShape.path = dateMaskPath.cgPath
            dateBlurEffect.layer.mask = dateShape
        }
    }
    
    // MARK: View Controller Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        playVideo()
//        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { [weak self] _ in
//            self?.player.seek(to: CMTime.zero)
//            self?.player.play()
//        }
        
        
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: CKNotificationName.tvSet.rawValue), object: nil, queue: .main) { _ in
            self.currentTV = (UIApplication.shared.delegate as! AppDelegate).currentTV
            self.currentTV.keynoteDelegate = self
            if let keynote = self.currentTV.keynote {
                self.keynoteBlurView = self.view.viewWithTag(1) as? UIVisualEffectView
                self.show(keynote: keynote)
            }else {
                self.keynoteBlurView = self.view.viewWithTag(1) as? UIVisualEffectView
                self.hideKeynote()
            }
            do {
                self.globalMessageView.globalMessages = try CKController.getAllGlobalMessages(completionHandler: {})
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        player.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        player.play()
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
        
//        player.play()
        
    }
    
    private func setDate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, HH:mm"
        
        self.dateLabel.text = dateFormatter.string(from: date)
    }
    
    private func setNormalFrame() {
        keynoteBlurView.autoPinEdge(toSuperviewEdge: .left, withInset:30)
        keynoteBlurView.autoPinEdge(toSuperviewEdge: .top, withInset:60)
        keynoteBlurView.autoSetDimensions(to: CGSize(width: 897, height: 550))
        globalMessageView.setLayout(type: .normal)
        
    }
    private func setKeynoteFrame() {
        keynoteBlurView.autoPinEdge(toSuperviewEdge: .left, withInset:30)
        keynoteBlurView.autoPinEdge(toSuperviewEdge: .top, withInset:60)
        keynoteBlurView.autoSetDimensions(to: CGSize(width: 457, height: 761))
        globalMessageView.setLayout(type: .keynote)
    }
   
}




extension BoardViewController: ATVKeynoteViewDelegate {
    func show(keynote: [UIImage]) {
//        Perform UI Keynote  Showing
        setKeynoteFrame()
        keynoteView.fadeIn()
        var page = 0
        keynoteView.image = keynote[page]
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            page = (page + 1) % keynote.count
            self.keynoteView.image = keynote[page]
        }
        
        
    }
    
    func hideKeynote() {
//        Perform UI Keynote hiding
        keynoteView.fadeOut()
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
