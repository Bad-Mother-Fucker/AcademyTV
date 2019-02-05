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

        fullImageView = UIImageView(frame: CGRect(x: 16, y: 14, width: UIScreen.main.bounds.width - 32, height: 206))
        fullImageView.image = fullImage
        fullImageView.contentMode = .scaleAspectFit

        self.contentView.addSubview(fullImageView)
    }

    /**
     ## Required Initializer

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
