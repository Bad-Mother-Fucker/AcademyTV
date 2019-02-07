//
//  AvAssets.swift
//  Viewer
//
//  Created by Michele De Sena on 05/02/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//

import Foundation
import AVFoundation

enum AVAssets: CaseIterable {
   static let elmo = AVURLAsset(url: URL(string: "https://dl.dropboxusercontent.com/s/jiygs4mqvfmube2/Elmo180.m4v?dl=0")!)
    static let floridiana = AVURLAsset(url: URL(string: "https://dl.dropboxusercontent.com/s/0s48rm38u8awzve/Floridiana180.m4v?dl=0")!)
    static let lungomare = AVURLAsset(url: URL(string: "https://dl.dropboxusercontent.com/s/pikrsmippuu59qq/Lungomare180.m4v?dl=0" )!)
    static let uovo = AVURLAsset(url: URL(string: "https://dl.dropboxusercontent.com/s/n0aczqi5irkhzcb/Uovo180.m4v?dl=0")!)
}
