//
//  BooquableOrder.swift
//  Viewer
//
//  Created by Gianluca Orpello on 20/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import Foundation

enum GliphName: String{
    case appleWatch = "Apple Watch"
    case applePencil = "Apple Pencil"
    case appleTV = "Apple TV"
    case ipadMini = "iPad Mini"
    case ipadPro = "iPad Pro"
    case iphone8 = "iPhone 8"
    case iphoneX = "iPhone X"
    case macMini = "Mac Mini"
}

class BooquableOrder{
    
    var id: String!
    var startAt: String!
    var stopsAt: String!
    var customer: NSDictionary!
    var lines: NSDictionary!
    
    init(id: String, startAt: String, stopsAt: String, customer: NSDictionary, lines: NSDictionary) {
        self.id = id
        self.startAt = startAt
        self.stopsAt = stopsAt
        self.customer = customer
        self.lines = lines
    }
    
    func customerName() -> String{
        let name = customer.value(forKey: "name") as! String
        return name
    }
    
    func getDevice() -> (name: String, glyph: GliphName){
        let deviceName = lines.value(forKey: "title") as! String
        let glyph = getGlypg(from: deviceName)
        return (name: deviceName, glyph: glyph)
    }
    
    private func getGlypg(from name: String) -> GliphName{
        if name.range(of: GliphName.appleWatch.rawValue) != nil{
            return .appleWatch
        }else if name.range(of: GliphName.applePencil.rawValue) != nil {
            return .applePencil
        }else if name.range(of: GliphName.appleTV.rawValue) != nil {
            return .appleTV
        }else if name.range(of: GliphName.ipadMini.rawValue) != nil {
            return .ipadMini
        }else if name.range(of: GliphName.ipadPro.rawValue) != nil {
            return .ipadPro
        }else if name.range(of: GliphName.macMini.rawValue) != nil {
            return .macMini
        }else if name.range(of: GliphName.iphoneX.rawValue) != nil {
            return .iphoneX
        }else{
            return .iphone8
        }
    }
    
}
