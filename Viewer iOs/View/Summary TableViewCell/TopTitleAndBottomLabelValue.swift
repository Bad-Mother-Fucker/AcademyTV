//
//  TopTitleAndBottomLabelValue.swift
//  Viewer
//
//  Created by Gianluca Orpello on 11/02/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//

import UIKit

/**
 ## Table View Cell with top title and bottom value description

 - Version: 1.0

 - Author: @GianlucaOrpello
 */
class TopTitleAndBottomLabelValue: UITableViewCell {

    /**
     ## The title of the button

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var title: String?{
        didSet{
            titleLabel.text = title
        }
    }

    /**
     ## The value of the button

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var valueText: String?{
        didSet{
            valueLabel.text = valueText
        }
    }

    /**
     ## The Title label of the cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var titleLabel: UILabel!

    /**
     ## The value Label of the cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var valueLabel: UILabel!

    /**
     ## initializer

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none

        titleLabel = UILabel()
        valueLabel = UILabel()

        titleLabel.text = title
        valueLabel.text = valueText
        valueLabel.textColor = UIColor(red: 0, green: 119/255, blue: 1, alpha: 1)
        valueLabel.numberOfLines = 0

        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(valueLabel)
        addVerticalConstraints(between: titleLabel, and: valueLabel)
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
