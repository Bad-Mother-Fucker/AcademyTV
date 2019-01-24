//
//  GlassOfficeTableViewCell.swift
//  Viewer
//
//  Created by Gianluca Orpello on 20/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

class GlassOfficeTableViewCell: UITableViewCell {

    @IBOutlet weak var blurEffect: UIVisualEffectView! {
        didSet {
            blurEffect.layer.cornerRadius = 20
            blurEffect.contentView.layer.cornerRadius = 20
            blurEffect.clipsToBounds = true
            blurEffect.contentView.clipsToBounds = true
            blurEffect.alpha = 0.8
        }
    }
    @IBOutlet weak var deviceImage: UIImageView!
    @IBOutlet weak var timingInformationLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var deviceNameLabel: UILabel!
}
