//
//  MessagesTableViewCell.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 24/10/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

/// This class are used for rappresent the Message Cell
class MessagesTableViewCell: UITableViewCell {

    var titleText: String?{
        didSet{
            titleLabel.text = titleText
        }
    }

    var descriptionText: String?{
        didSet{
            descriptionLabel.text = descriptionText
        }
    }
    
    var location: String? {
        didSet{
            locationLabel.text = location
        }
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
}
