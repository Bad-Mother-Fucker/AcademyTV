//
//  MasterAndDetailLabelsTableViewCell.swift
//  Viewer
//
//  Created by Gianluca Orpello on 05/02/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//

import UIKit

/**
 ## Master And Detail Labels TableViewCell

 - Version: 1.0

 - Author: @GianlucaOrpello
 */
class MasterAndDetailLabelsTableViewCell: UITableViewCell {

    /**
     ## Main text

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var mainText: String?{
        didSet{
            mainLabel.text = mainText
        }
    }

    /**
     ## Detail Text

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var detailText: String?{
        didSet{
            detailLabel.text = detailText
        }
    }

    /**
     ## Main Label

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var mainLabel: UILabel!{
        didSet{
            addConstraints(to: mainLabel)
        }
    }


    /**
     ## Detail Label

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var detailLabel: UILabel!{
        didSet{
            addConstraints(to: detailLabel)
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

        mainLabel = UILabel()
        mainLabel.text = mainText

        detailLabel = UILabel()
        detailLabel.textColor = .lightGray
        detailLabel.textAlignment = .right
        detailLabel.tag = 500

        self.contentView.addSubview(mainLabel)
        self.contentView.addSubview(detailLabel)
        addConstraints(to: mainLabel, and: detailLabel)
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
