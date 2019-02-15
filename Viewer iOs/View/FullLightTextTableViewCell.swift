//
//  FullLightTextTableViewCell.swift
//  Viewer
//
//  Created by Gianluca Orpello on 30/01/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//

import UIKit

/**
 ## Full Light Text TableViewCell

 - Version: 1.0

 - Author: @GianlucaOrpello
 */
class FullLightTextTableViewCell: UITableViewCell {

    /**
     ## The text of the cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var fullText: String?{
        didSet{
            label.text = fullText
        }
    }

    /**
     ## The color of the text

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var fullTextColor: UIColor?{
        didSet{
            label.textColor = fullTextColor ?? .lightGray
        }
    }

    /**
     ## The font of the text

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var fullTextFont: UIFont?{
        didSet{
            label.font = fullTextFont ?? UIFont.systemFont(ofSize: 13)
        }
    }

    /**
     ## The SuperView of the cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var isFullSize: Bool = true{
        didSet{
            if isFullSize{
                addConstraintsWithSafeArea(to: label)
            }
        }
    }

    /**
     ## The label

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var label: UILabel!{
        didSet{
            addConstraintsWithSafeArea(to: label)
        }
    }

    /**
     ## Initializer

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

        label = UILabel()

        label.numberOfLines = 0
        label.font = fullTextFont ?? UIFont.systemFont(ofSize: 13)
        label.textColor = fullTextColor ?? .lightGray
        label.text = fullText

        self.contentView.addSubview(label)
        if isFullSize{
            addConstraintsWithSafeArea(to: label)
        }
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
