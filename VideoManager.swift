//
//  VideoManager.swift
//  Viewer
//
//  Created by Michele De Sena on 12/12/2018.
//  Copyright © 2018 Team Rogue. All rights reserved.
//

import Foundation
import AVFoundation


/**
 ## VideoManager - TVOS
 
 - Note: Class for managing video download and play
 
 - SeeAlso: VideoDownloader
 
 - Version: 1.0
 
 - Author: @Micheledes
 */

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
    
    /**
     ## currentPlayingVideo
    
     
     - Return: AVPlayerItem?
     
     
     - SeeAlso: videos
     
     - Note: gets the current playing video on the current TV
     
     - Version: 1.0
     
     - Author: @Micheledes
     */
    
    var currentPlayingVideo: AVPlayerItem? {
        return player.currentItem
    }
    
    /**
     ## videos
     
     
     - Return: AVPlayerItem?
     
     
     - SeeAlso: currentPlayingVideo
     
     - Note: the set of videos used as background in the app
     
     - Version: 1.0
     
     - Author: @Micheledes
     */
    
    var videos: [AVPlayerItem] {
        get { return playingVideos }
    }
    
    private var player: AVPlayer!
    
    func playVideo() {
        player.play()
    }
    
    /**
     ## startFromBeginnig()
     
     - Note: Starts the player from the first video of the current set
     
     - Version: 1.0
     
     - Author: @Micheledes
     */
    
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
        if currentIndex >= 0 && currentIndex < (videos.count - 1) {
            return currentIndex + 1
        }else {
            currentIndex = 0
            return currentIndex
        }
    }

    
}

/**
 ## VideoDownloader
 

 - SeeAlso: VideoManager

 - Note: Takes care of the videos been downloaded within the app
 
 - Version: 1.0
 
 - Author: @Micheledes
 */


class VideoDownloader {
    
    /**
     ## downloadVideosFrom(URLs:)

     
     - SeeAlso: getVideos(from:)
     
     - Note: downloads the videos from dropbox storage
     
     - Version: 1.0
     
     - Author: @Micheledes
     */
    
    
    static private func downloadVideosFrom(URLs: [URL]) {
        
        DispatchQueue.global(qos: .background).async {
            var localURLs: [URL] = []
            URLs.forEach({ (url) in
                if let urlData = NSData(contentsOf: url) {
                    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                    let filePath="\(documentsPath)/video\(URLs.index(of: url)!).mp4"
                    
                    urlData.write(toFile: filePath, atomically: true)
                    localURLs.append(URL(fileURLWithPath: filePath))
                    
                }
            })
            
            let defaults = UserDefaults.standard
            let data = NSKeyedArchiver.archivedData(withRootObject: localURLs)
            defaults.setValue(data, forKey: "videoURLs")
            
        }
    }
    

    /**
     ## getVideos(from:)
     
     - Parameters:
     - <#Parameter#>

     
     - Return: <#Return#>

     
     - Note: If there is any video stored in userdefaults it returns the urls of the user default folder where the videos are stored. Otherwise it starts downloading them, and in the meanwhile returns the dropbox video urls
     
     - Version: 1.0
     
     - Author: @Micheledes
     */
    
    static func getVideos(from urls: [URL]) -> [URL] {
        if let videoData = UserDefaults.standard.value(forKey: "videoURLs") as? Data {
            if let urlsArray = NSKeyedUnarchiver.unarchiveObject(with: videoData) as? [URL] {
                return urlsArray
            } else {
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
