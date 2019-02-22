//
//  TvGroups.swift
//  Viewer
//
//  Created by Andrea Belcore on 21/01/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//

import Foundation

var trueTvNames: [TVGroup: String] = [
    TVGroup.lab1 : "Lab 1",
    TVGroup.lab2 : "Lab 2",
    TVGroup.lab3 : "Lab 3",
    TVGroup.lab4 : "Lab 4",
    TVGroup.br1 : "Boardroom 1",
    TVGroup.br2 : "Boardroom 2",
    TVGroup.br3 : "Boardroom 3",
    TVGroup.collab1 : "Collab 1",
    TVGroup.collab2 : "Collab 2",
    TVGroup.collab3 : "Collab 3",
    TVGroup.collab4 : "Collab 4",
    TVGroup.all : "Glass Office",
    TVGroup.kitchen : "Kitchen",
    TVGroup.seminar : "Main Classroom"
]

var globalGroups = [
    TVGroupCellData(name: .lab1,
             tvList: ["01", "02", "03", "04", "05", "06"],
             startingColor: (red: 62, green: 154, blue: 186),
             endingColor: (red: 29, green: 97, blue: 132)),
    TVGroupCellData(name: .collab1,
             tvList: ["01", "02", "03", "04"],
             startingColor: (red: 251, green: 201, blue: 72),
             endingColor: (red: 245, green: 152, blue: 35)),
    TVGroupCellData(name: .lab2,
             tvList: ["01", "02", "03", "04"],
             startingColor: (red: 224, green: 86, blue: 109),
             endingColor: (red: 182, green: 23, blue: 39)),
    TVGroupCellData(name: .collab2,
             tvList: ["01", "02", "03", "04", "05", "06"],
             startingColor: (red: 131, green: 67, blue: 221),
             endingColor: (red: 76, green: 32, blue: 184)),
    TVGroupCellData(name: .lab3,
             tvList: ["01", "02", "03", "04", "05", "06", "07", "08"],
             startingColor: (red: 251, green: 201, blue: 72),
             endingColor: (red: 245, green: 152, blue: 35)),
    TVGroupCellData(name: .collab3,
             tvList: ["01", "02", "03", "04", "05", "06"],
             startingColor: (red: 0, green: 124, blue: 222),
             endingColor: (red: 0, green: 70, blue: 186)),
    TVGroupCellData(name: .lab4,
             tvList: ["01", "02", "03", "04"],
             startingColor: (red: 62, green: 154, blue: 186),
             endingColor: (red: 29, green: 97, blue: 132)),
    TVGroupCellData(name: .collab4,
             tvList: ["01", "02", "03", "04"],
             startingColor: (red: 2, green: 162, blue: 144),
             endingColor: (red: 1, green: 105, blue: 87)),
    TVGroupCellData(name: .seminar,
             tvList: ["Seminar"],
             startingColor: (red: 131, green: 67, blue: 221),
             endingColor: (red: 76, green: 32, blue: 184)),
    TVGroupCellData(name: .kitchen,
             tvList: ["Kitchen"],
             startingColor: (red: 217, green: 195, blue: 172),
             endingColor: (red: 178, green: 144, blue: 116)),
    TVGroupCellData(name: .br1,
             tvList: ["01", "02"],
             startingColor: (red: 224, green: 86, blue: 109),
             endingColor: (red: 182, green: 23, blue: 39)),
    TVGroupCellData(name: .br2,
             tvList: ["01", "02"],
             startingColor: (red: 251, green: 201, blue: 72),
             endingColor: (red: 245, green: 152, blue: 35)),
    TVGroupCellData(name: .br3,
             tvList: ["01", "02"],
             startingColor: (red: 0, green: 124, blue: 222),
             endingColor: (red: 0, green: 70, blue: 186)),
    TVGroupCellData(name: .all,
             tvList: ["01"],
             startingColor: (red: 0, green: 201, blue: 227),
             endingColor: (red: 0, green: 153, blue: 194))
]

struct TVGroupCellData {
    var name: TVGroup
    var tvList: [String]
    var startingColor: (red: Float, green: Float, blue: Float)
    var endingColor: (red: Float, green: Float, blue: Float)
}
