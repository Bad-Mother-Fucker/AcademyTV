//
//  PropsTableViewCell.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 27/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

/**
 ## Left Image And Description TableViewCell

  This table view cell are used for display one text and one icon associated.
 
 - Version: 1.0
 
 - Author: @GianlucaOrpello
 */
class LeftImageAndDescriptionTableViewCell: UITableViewCell {

    /**
     ## The Image of the cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var leftImage: UIImage?{
        didSet{
            leftImageView.image = leftImage
        }
    }

    /**
     ## The title of the cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var title: String?{
        didSet{
            titleLabel.text = title
        }
    }

    /**
     ## The description of the cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var descriptions: String?{
        didSet{
            descriptionLabel.text = descriptions
        }
    }

    /**
     ## Left Imahe View

     The UIImageView used for display the icon.

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var leftImageView: UIImageView!

    /**
     ## Title Label

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var titleLabel: UILabel!

    /**
     ## Descriprion Label

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var descriptionLabel: UILabel!
    
    /**
     ## UITableViewCell - Initializer
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        
        leftImageView = UIImageView()
        titleLabel = UILabel()
        descriptionLabel = UILabel()

        leftImageView.image = leftImage
        leftImageView.contentMode = .scaleAspectFit

        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .black

        descriptionLabel.text = descriptions
        descriptionLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        descriptionLabel.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        descriptionLabel.numberOfLines = 0
        
        self.contentView.addSubview(leftImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)
        addConstraits()
    }
    
    /**
     ## UITableViewCell - Required Initializer
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.accessoryType = .disclosureIndicator
        
        leftImageView = UIImageView()
        titleLabel = UILabel()
        descriptionLabel = UILabel()
        
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
     ## Add Action to the button

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private func addConstraits(){
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        let safeArea = self.safeAreaLayoutGuide

        leftImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10).isActive = true
        leftImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        leftImageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10).isActive = true
        leftImageView.widthAnchor.constraint(equalTo: leftImageView.heightAnchor, constant: 0).isActive = true

        titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 22).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -32).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 22)

        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -32).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10).isActive = true
    }
}
