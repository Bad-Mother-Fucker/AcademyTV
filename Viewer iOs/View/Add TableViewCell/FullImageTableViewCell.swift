//
//  FullImageTableViewCell.swift
//  Viewer
//
//  Created by Gianluca Orpello on 30/01/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//

import UIKit

/**
 ## Table View Cell with full image.

 - Version: 1.0

 - Author: @GianlucaOrpello
 */
class FullImageTableViewCell: UITableViewCell {

    /**
     ## The Image of the Cell.

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var fullImage: UIImage?{
        didSet{
            fullImageView.image = fullImage
        }
    }

    /**
     ## The imageView of the cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var fullImageView: UIImageView!

    /**
     ## Initializer

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

        fullImageView = UIImageView()
        fullImageView.image = fullImage
        fullImageView.contentMode = .scaleAspectFit

        self.contentView.addSubview(fullImageView)
        addConstraintsWithSafeArea(to: fullImageView)
    }

    /**
     ## Required Initializer

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     ## Add Constraints

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    override func addConstraintsWithSafeArea(to view: UIView){
        view.translatesAutoresizingMaskIntoConstraints = false

        let safeArea = self.safeAreaLayoutGuide

        view.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 14).isActive = true
        view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
        view.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -14).isActive = true
        view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true

        self.contentView.layoutIfNeeded()
    }
}
