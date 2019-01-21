//
//  PropsTableViewCell.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 27/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

/**
 ## Props TableView Cell.
 
 Used for display the list of table view.
 
 - Version: 1.0
 
 - Author: @GianlucaOrpello
 */
class PropsTableViewCell: UITableViewCell {

    var leftImageView: UIImageView!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    
    /**
     ## UITableViewCell - Initializer
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    init() {
        super.init(style: .default, reuseIdentifier: "PropsTableViewCell")
        
        self.accessoryType = .disclosureIndicator
        
        leftImageView = UIImageView(frame: CGRect(x: 17, y: 10, width: 60, height: 60))
        titleLabel = UILabel(frame: CGRect(x: 92, y: 22, width: 250, height: 22))
        descriptionLabel = UILabel(frame: CGRect(x: 92, y: 45, width: 250, height: 30))
        
        leftImageView.contentMode = .scaleAspectFit
        
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .black
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        descriptionLabel.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        descriptionLabel.numberOfLines = 0
        
        self.contentView.addSubview(leftImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)
    }
    
    /**
     ## UITableViewCell - Required Initializer
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.accessoryType = .disclosureIndicator
        
        leftImageView = UIImageView(frame: CGRect(x: 17, y: 10, width: 60, height: 60))
        titleLabel = UILabel(frame: CGRect(x: 92, y: 22, width: 250, height: 22))
        descriptionLabel = UILabel(frame: CGRect(x: 92, y: 45, width: 250, height: 30))
        
        leftImageView.contentMode = .scaleAspectFit
        
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .black
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        descriptionLabel.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        descriptionLabel.numberOfLines = 0

        
        self.contentView.addSubview(leftImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)
    }
}
