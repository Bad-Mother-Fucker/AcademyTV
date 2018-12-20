//
//  VideoManager.swift
//  Viewer
//
//  Created by Michele De Sena on 12/12/2018.
//  Copyright © 2018 Team Rogue. All rights reserved.
//

import Foundation
import AVFoundation

class VideoManager {
    
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
    
//    func startFromBeginnig() {
//        player.replaceCurrentItem(with: videos.first!)
//        player.seek(to: CMTime.zero)
//        player.play()
//    }
    
    func nextVideo() {
        player.replaceCurrentItem(with: videos[nextVideoIndex()])
        player.seek(to: CMTime.zero)
        player.play()
    }
    
    private func nextVideoIndex() -> Int {
        guard let currentVideo = currentPlayingVideo else { return 0 }
        var currentIndex = videos.index(of: currentVideo)!
        if currentIndex >= 0 && currentIndex < (videos.count - 1) {
            return currentIndex + 1
        }else {
            currentIndex = 0
            return currentIndex
        }
    }
    
}

class VideoDownloader {
    
<<<<<<< HEAD

    
    
    
}

class VideoDownloader {
=======
>>>>>>> master
    static private func downloadVideosFrom(URLs:[URL]) {
        
        DispatchQueue.global(qos: .background).async {
            var localURLs: [URL] = []
            URLs.forEach({ (url) in
                if let urlData = NSData(contentsOf: url) {
                    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                    let filePath="\(documentsPath)/video\(URLs.index(of:url)!).mp4"
                    
                    urlData.write(toFile: filePath, atomically: true)
                    localURLs.append(URL(fileURLWithPath: filePath))
                    
                }
            })
            
            let defaults = UserDefaults.standard
            let data = NSKeyedArchiver.archivedData(withRootObject: localURLs)
            defaults.setValue(data, forKey: "videoURLs")
            
        }
    }
    
    
//    Al primo avvio ritorna le URL dei video su dropbox e in contemporanea li salva su userdefaults
//    Dal secondo avvio ritorna i video salvati su userdefaults
    static func getVideos(from urls: [URL]) -> [URL] {
        if let videoData = UserDefaults.standard.value(forKey: "videoURLs") as? Data {
            if let urlsArray = NSKeyedUnarchiver.unarchiveObject(with: videoData) as? [URL] {
                return urlsArray
            }else {
                print("Error unarchiving video files, donwloading from dropbox")
                VideoDownloader.downloadVideosFrom(URLs: urls)
                return urls
            }
        } else {
            VideoDownloader.downloadVideosFrom(URLs: urls)
            return urls
        }
    }
}



