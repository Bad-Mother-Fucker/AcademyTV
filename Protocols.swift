//
//  File.swift
//  Viewer
//
//  Created by Gianluca Orpello on 05/02/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//

import UIKit
import CloudKit

/**
 ## CloudStored

 - Note: The protocol adopted by every data model stored in cloudkit

 - Version: 1.0

 - Author: @Micheledes
 */
protocol CloudStored {
    var record: CKRecord { get set }
    static var recordType: String { get }
    init(record: CKRecord)
}

/**
 ## CKQueryException

 - Parameters:
 - connectionTimedOut: Thrown when a query takes too long to be executed
 - recordNotFound: Thrown when a requested record is not found in the database

 - Note: Enum containing the custom exceptions

 - Version: 1.0

 - Author: @Micheledes
 */
enum CKQueryException: Error {
    case connectionTimedOut(String)
    case recordNotFound(String)
}

/**
 ## CKNotificationName

 - Note: Enum containing the notification names used by the notification center

 - Version: 1.0

 - Author: @Micheledes
 */
enum CKNotificationName: String {
    case globalMessages = "global messages notification"
    case tv = "tv notification"
    case serviceMessage = "service message notification"
    case null = ""
    case notification = "notification"
    case tvSet = "currentTvSet"
    case serviceMessageSet = "serviceMessageSet"


    enum MessageNotification: String {
        case create = "msgCreated"
        case delete = "msgDeleted"
        case update = "msgUpdated"
    }
}

/**
 ## CKKeys

 - Note: Enum containing the subscription keys for cloudkit

 - Version: 1.0

 - Author: @Micheledes
 */
enum CKKeys {

    static let database = CKContainer(identifier: "iCloud.com.TeamRogue.Viewer").publicCloudDatabase
    static let messageSubscriptionKey = "CKMessageSubscription"
    static let tvSubscriptionKey = "CKTVSubscription"
    static let serviceSubscriptionKey = "CKServiceMessageSubscription"
}

protocol ATVViewDelegate {
    func show(keynote: [UIImage])
    func hideKeynote()
    func show(ticker: String)
    func hideTicker()
}

enum TVGroup: String{
    case lab1 = "Lab-01"
    case lab2 = "Lab-02"
    case lab3 = "Lab-03"
    case lab4 = "Lab-04"
    case collab1 = "Collab-01"
    case collab2 = "Collab-02"
    case collab3 = "Collab-03"
    case collab4 = "Collab-04"
    case br1 = "BR-01"
    case br2 = "BR-02"
    case br3 = "BR-03"
    case kitchen = "kitchen"
    case seminar = "seminar"
    case all = "all"
}

enum Locations: String, CaseIterable {
    case none = "None"
    case seminar = "Main Classroom"
    case kitchen = "Kitchen"
    case br1 = "Boardroom 1"
    case br2 = "Boardroom 2"
    case br3 = "Boardroom 3"
    case lab1 = "Lab 1"
    case collab1 = "Collab-01"
    case lab2 = "Lab 2"
    case collab2 = "Collab-02"
    case lab3 = "Lab 3"
    case collab3 = "Collab-03"
    case lab4 = "Lab 4"
    case collab4 = "Collab-04"
}
