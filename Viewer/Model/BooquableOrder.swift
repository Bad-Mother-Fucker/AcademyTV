//
//  BooquableOrder.swift
//  Viewer
//
//  Created by Gianluca Orpello on 20/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import Foundation

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
    
    func getDeviceName() -> String{
        let deviceName = lines.value(forKey: "title") as! String
        return deviceName
    }
    
}
