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
    
    @IBOutlet weak var keynoteView: UIImageView! {
        didSet{
            keynoteView.isHidden = true
        }
    }
    
    
    // MARK: Contextual Label
    @IBOutlet weak var tvNameLabel: UILabel!{
        didSet{
            tvNameLabel.text = UIDevice.current.name
        }
    }
    
    @IBOutlet weak var globalMessageView: GlobalMessageView!
    
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
//        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { [weak self] _ in
//            self?.player.seek(to: CMTime.zero)
//            self?.player.play()
//        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: CKNotificationName.tvSet.rawValue), object: nil, queue: .main) { _ in
            self.currentTV = (UIApplication.shared.delegate as! AppDelegate).currentTV
            self.currentTV.keynoteDelegate = self
            if let keynote = self.currentTV.keynote {
                self.show(keynote: keynote)
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
   
}

extension BoardViewController: ATVKeynoteViewDelegate {
    func show(keynote: [UIImage]) {
//        Perform UI Keynote  Showing
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
