//
//  BorderCollectionViewCell.swift
//  Viewer
//
//  Created by Gianluca Orpello on 14/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

/// This class are used for rappresent the Border Cell
class BorderCollectionViewCell: UICollectionViewCell {

    var titleText: String?{
        didSet{
            titleLabel.text = titleText
        }
    }
    
    /**
     The outlat linked to the title of the cell.
     */
    @IBOutlet private weak var titleLabel: UILabel!
    
    /**
     Override the basic isSelected variables for customise the behavior when change.
     
     - Returns: A new string saying hello to `recipient`.
     */
    override var isSelected: Bool{
        didSet{
            if isSelected{
                self.titleLabel.text = "Deselect All"
            } else {
                self.titleLabel.text = "Select All"
            }
        }
    }
    
    /**
     Prepares the receiver for service after it has been loaded from an Interface Builder archive, or nib file..
     */
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.cornerRadius = 10
        
    }
}
