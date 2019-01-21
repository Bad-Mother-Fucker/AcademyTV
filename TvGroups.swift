//
//  TvGroups.swift
//  Viewer
//
//  Created by Andrea Belcore on 21/01/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//

import Foundation

var globalGroups = [
    TVGroups(name: .lab1,
             tvList: ["01", "02", "03", "04", "05", "06"],
             startingColor: (red: 56, green: 204, blue: 175),
             endingColor: (red: 0, green: 165, blue: 144)),
    TVGroups(name: .collab1,
             tvList: ["01", "02", "03", "04"],
             startingColor: (red: 251, green: 131, blue: 23),
             endingColor: (red: 255, green: 89, blue: 0)),
    TVGroups(name: .lab2,
             tvList: ["01", "02", "03", "04"],
             startingColor: (red: 240, green: 182, blue: 0),
             endingColor: (red: 230, green: 132, blue: 0)),
    TVGroups(name: .collab2,
             tvList: ["01", "02", "03", "04", "05", "06"],
             startingColor: (red: 78, green: 169, blue: 241),
             endingColor: (red: 0, green: 120, blue: 223)),
    TVGroups(name: .lab3,
             tvList: ["01", "02", "03", "04", "05", "06", "07", "08"],
             startingColor: (red: 78, green: 169, blue: 241),
             endingColor: (red: 0, green: 120, blue: 223)),
    TVGroups(name: .collab3,
             tvList: ["01", "02", "03", "04", "05", "06"],
             startingColor: (red: 251, green: 131, blue: 23),
             endingColor: (red: 225, green: 89, blue: 0)),
    TVGroups(name: .lab4,
             tvList: ["01", "02", "03", "04"],
             startingColor: (red: 240, green: 182, blue: 0),
             endingColor: (red: 230, green: 132, blue: 0)),
    TVGroups(name: .collab4,
             tvList: ["01", "02", "03", "04"],
             startingColor: (red: 56, green: 204, blue: 175),
             endingColor: (red: 0, green: 165, blue: 144)),
    TVGroups(name: .seminar,
             tvList: ["Seminar"],
             startingColor: (red: 239, green: 98, blue: 168),
             endingColor: (red: 205, green: 32, blue: 122)),
    TVGroups(name: .kitchen,
             tvList: ["Kitchen"],
             startingColor: (red: 115, green: 117, blue: 121),
             endingColor: (red: 82, green: 84, blue: 87)),
    TVGroups(name: .br1,
             tvList: ["01", "02"],
             startingColor: (red: 240, green: 182, blue: 0),
             endingColor: (red: 230, green: 132, blue: 0)),
    TVGroups(name: .br2,
             tvList: ["01", "02"],
             startingColor: (red: 56, green: 204, blue: 175),
             endingColor: (red: 0, green: 165, blue: 144)),
    TVGroups(name: .br3,
             tvList: ["01", "02"],
             startingColor: (red: 239, green: 98, blue: 168),
             endingColor: (red: 205, green: 32, blue: 122)),
    TVGroups(name: .all,
             tvList: ["01"],
             startingColor: (red: 0, green: 201, blue: 227),
             endingColor: (red: 0, green: 153, blue: 194))
]

struct TVGroups{
    var name: TVGroup
    var tvList: [String]
    var startingColor: (red: Float, green: Float, blue: Float)
    var endingColor: (red: Float, green: Float, blue: Float)
}
