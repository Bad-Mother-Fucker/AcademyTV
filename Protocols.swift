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

    static let database = CKContainer(identifier: "iCloud.com.Rogue.Viewer").publicCloudDatabase
    static let messageSubscriptionKey = "CKMessageSubscription"
    static let tvSubscriptionKey = "CKTVSubscription"
    static let serviceSubscriptionKey = "CKServiceMessageSubscription"
}

protocol KeynoteViewerDelegate {
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

/**
 ## List of categories section of the table view.

 - Version: 1.0

 - Author: @GianlucaOrpello
 */
enum Categories: String{
    case tickerMessage = "Ticker Message"
    case keynoteViewer = "Content Viewer"
    case timer = "Timer"
    case globalMessage = "Global Message"
}

/**
 ## PropsListDelegate

 - Version: 1.0

 - Author: @GianlucaOrpello
 */
protocol PropsListDelegate {
    func getAiringProp()
}

extension UIView{

    /**
     ## Add Constraints with SafeArea

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    @objc func addConstraintsWithSafeArea(to view: UIView){
        view.translatesAutoresizingMaskIntoConstraints = false

        let safeArea = self.safeAreaLayoutGuide

        view.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10).isActive = true
        view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
        view.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10).isActive = true
        view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true

        self.layoutIfNeeded()
    }

    /**
     ## Add Constraints with SuperView

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    @objc func addConstraintsWithSuperView(to view: UIView){
        view.translatesAutoresizingMaskIntoConstraints = false

        let safeArea = self.safeAreaLayoutGuide

        view.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0).isActive = true

        self.layoutIfNeeded()
    }

    /**
     ## Add Constraints

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    @objc func addHorizontalConstraints(between view: UIView, and secondView: UIView){
        view.translatesAutoresizingMaskIntoConstraints = false
        secondView.translatesAutoresizingMaskIntoConstraints = false

        let safeArea = self.safeAreaLayoutGuide

        view.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
        secondView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true

        view.trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -16).isActive = true
        view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true

        secondView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
        secondView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7).isActive = true

        self.layoutIfNeeded()
    }

    /**
     ## Add Constraints

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    @objc func addVerticalConstraints(between view: UIView, and secondView: UIView){
        view.translatesAutoresizingMaskIntoConstraints = false
        secondView.translatesAutoresizingMaskIntoConstraints = false

        let safeArea = self.safeAreaLayoutGuide

        view.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16).isActive = true
        view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
        view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 89).isActive = true
        view.bottomAnchor.constraint(equalTo: secondView.topAnchor, constant: -7).isActive = true
        view.heightAnchor.constraint(equalToConstant: 22)

        secondView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
        secondView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 89).isActive = true
        secondView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16).isActive = true
//        secondView.heightAnchor.constraint(equalToConstant: 44).isActive = true

        self.layoutIfNeeded()
    }
}
