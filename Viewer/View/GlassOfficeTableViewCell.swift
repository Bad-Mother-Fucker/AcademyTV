//
//  GlassOfficeTableViewCell.swift
//  Viewer
//
//  Created by Gianluca Orpello on 20/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

class GlassOfficeTableViewCell: UITableViewCell {

    var userName: String? {
        didSet {
            userNameLabel.text = userName
        }
    }

    var deviceName: String? {
        didSet {
            deviceNameLabel.text = deviceName
        }
    }

    var timingInformation: String? {
        didSet {
            timingInformationLabel.text = timingInformation
        }
    }

    var device: UIImage? {
        didSet {
            deviceImage.image = device
        }
    }

    @IBOutlet private weak var blurEffect: UIVisualEffectView! {
        didSet {
            blurEffect.layer.cornerRadius = 20
            blurEffect.contentView.layer.cornerRadius = 20
            blurEffect.clipsToBounds = true
            blurEffect.contentView.clipsToBounds = true
            blurEffect.alpha = 0.8
        }
    }
    @IBOutlet private weak var deviceImage: UIImageView!
    @IBOutlet private weak var timingInformationLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var deviceNameLabel: UILabel!
}
