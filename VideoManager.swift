//
//  VideoManager.swift
//  Viewer
//
//  Created by Michele De Sena on 12/12/2018.
//  Copyright © 2018 Team Rogue. All rights reserved.
//

import Foundation
import AVFoundation

class VideoManger {
    
    init(onLayer parentLayer: CALayer, videos: [AVPlayerItem]) {
        playingVideos = videos
        player = AVPlayer(playerItem: videos.first)
        player.actionAtItemEnd = .none
        player.isMuted = true
        player.rate = 0.8
        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        layer.zPosition = -1
        layer.frame = parentLayer.frame
        parentLayer.addSublayer(layer)
    }
    
    private var playingVideos: [AVPlayerItem]
    
    var currentPlayingVideo: AVPlayerItem? {
        return player.currentItem
    }
    
    var videos: [AVPlayerItem] {
        get { return playingVideos }
    }
    
    private var player: AVPlayer!
    
    func playVideo() {
        player.play()
    }
    
    func startFromBeginnig() {
        player.replaceCurrentItem(with: videos.first!)
        player.seek(to: CMTime.zero)
        player.play()
    }
    
    func nextVideo() {
        player.replaceCurrentItem(with: videos[nextVideoIndex()])
        player.seek(to: CMTime.zero)
        player.play()
    }
    
    private func nextVideoIndex() -> Int {
        guard let currentVideo = currentPlayingVideo else { return 0 }
        var currentIndex = videos.index(of: currentVideo)!
        if currentIndex >= 0 && currentIndex < videos.count {
            return currentIndex + 1
        }else {
            currentIndex = 0
            return currentIndex
        }
    }

    
    static func getVideos() {
        let videoImageUrl = "https://dl.dropboxusercontent.com/s/jiygs4mqvfmube2/Elmo180.m4v?dl=0"
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: videoImageUrl),
                let urlData = NSData(contentsOf: url) {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                let filePath="\(documentsPath)/video.mp4"
                DispatchQueue.main.async {
                    urlData.write(toFile: filePath, atomically: true)
                    UserDefaults.standard.set(URL(fileURLWithPath: filePath), forKey: "videofile")
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }
    
    
    
}

