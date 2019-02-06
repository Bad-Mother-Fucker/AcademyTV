//
//  BooquableOrder.swift
//  Viewer
//
//  Created by Gianluca Orpello on 20/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import Foundation

/**
 ## Enumeration with all the device available
 
 This is a list of all the device name that are collectable.
 
 - Version: 1.0
 
 - Author: @GianlucaOrpello
 */
enum GliphName: String {
    case appleWatch = "Apple Watch"
    case applePencil = "Apple Pencil"
    case appleTV = "Apple TV"
    case ipadMini = "iPad Mini"
    case ipadPro = "iPad Pro"
    case iphone8 = "iPhone 8"
    case iphoneX = "iPhone X"
    case macMini = "Mac Mini"
}

/**
 ## Booquable Order
 
 This class rappresent a generic order from Booquable.
 
 - SeeAlso: For more info see the [Booquable Documentation](https://booqable.com/blog/booqable-api-documentation/)
 
 - Version: 1.0
 
 - Author: @GianlucaOrpello
 */
class BooquableOrder {
    
    // MARK: - Public API
    var id: String!
    var startAt: String!
    var stopsAt: String!
    var customer: NSDictionary!
    var lines: NSDictionary!
    
    // MARK: - Init
    
    /**
     ## Class initializer
     
     - Parameters:
        - id: The id ot the order inside Booquable.
        - startAt: The date of the begginning of the order.
        - stopAt: The date of the ending of the order.
        - customer: The associated customer at the order.
        - lines: The line associated at the order, usefull for get the device info.
     
     - Remark: Initializer
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    init(id: String, startAt: String, stopsAt: String, customer: NSDictionary, lines: NSDictionary) {
        self.id = id
        self.startAt = startAt
        self.stopsAt = stopsAt
        self.customer = customer
        self.lines = lines
    }
    
    // MARK: - Public function
    
    /**
     ## Get the customer name
     
     - Return: The name of the customer associated to the order
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func customerName() -> String {
        guard let name = customer.value(forKey: "name") as? String else { return "" }
        return name
    }
    
    /**
     ## Get the device name
     
     - Return: A tuple with the device name and the gliph name associated to the order
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func getDevice() -> (name: String, glyph: GliphName) {
        guard let deviceName = lines.value(forKey: "title") as? String else { return (name:"", glyph:GliphName.iphoneX) }
        let glyph = getGliph(from: deviceName)
        return (name: deviceName, glyph: glyph)
    }
    
    // MARK: - Private function
    
    /**
     ## Obtain the gliph name
     
     Get the GliphName key associated to the order, based on the name of the device
     
     - Parameters:
        - name: The litteral name of the device
     
     - Return: The raw value of the gliph associated to the device name
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    private func getGliph(from name: String) -> GliphName {
        if name.range(of: GliphName.appleWatch.rawValue) != nil {
            return .appleWatch
        } else if name.range(of: GliphName.applePencil.rawValue) != nil {
            return .applePencil
        } else if name.range(of: GliphName.appleTV.rawValue) != nil {
            return .appleTV
        } else if name.range(of: GliphName.ipadMini.rawValue) != nil {
            return .ipadMini
        } else if name.range(of: GliphName.ipadPro.rawValue) != nil {
            return .ipadPro
        } else if name.range(of: GliphName.macMini.rawValue) != nil {
            return .macMini
        } else if name.range(of: GliphName.iphoneX.rawValue) != nil {
            return .iphoneX
        } else {
            return .iphone8
        }
    }
}
