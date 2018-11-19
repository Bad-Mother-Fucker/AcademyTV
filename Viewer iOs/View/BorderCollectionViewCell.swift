//
//  BorderCollectionViewCell.swift
//  Viewer
//
//  Created by Gianluca Orpello on 14/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

class BorderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.cornerRadius = 5
    }
}
