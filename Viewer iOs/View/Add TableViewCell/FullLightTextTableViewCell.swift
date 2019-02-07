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
     ## The label

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var label: UILabel!{
        didSet{
            addConstraints(to: label)
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
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .lightGray
        label.text = fullText

        self.contentView.addSubview(label)
        addConstraints(to: label)
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
