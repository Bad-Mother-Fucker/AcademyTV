//
//  GlobalMessages.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 24/10/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import Foundation
import CloudKit

struct GlobalMessage {
    var recordID: CKRecord.ID
    var title: String
    var subtitle: String
    var location: String
    var description: String
    var creationDate: Date
}
