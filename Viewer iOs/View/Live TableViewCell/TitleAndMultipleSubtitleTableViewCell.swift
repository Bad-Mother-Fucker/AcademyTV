//
//  TitleAndSubtitleTableViewCell.swift
//  Viewer
//
//  Created by Gianluca Orpello on 29/01/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//

import UIKit

/**
 ## UITableViewCell with title and multiple subtitle

 - Version: 1.0

 - Author: @GianlucaOrpello
 */
class TitleAndMultipleSubtitleTableViewCell: UITableViewCell {

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
     ## The subtitle of the cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var subtitle: String?{
        didSet{
            subtitleLabel.text = subtitle
        }
    }

    /**
     ## The title label of the cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var titleLabel: UILabel!

    /**
     ## The subtitle label of the cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var subtitleLabel: UILabel!

    /**
     ## Initializer

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.accessoryType = .detailButton
        self.selectionStyle = .none

        titleLabel = UILabel(frame: CGRect(x: 16, y: 16, width: 350, height: 44))
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .black

        subtitleLabel = UILabel(frame: CGRect(x: 16, y: 66, width: 350, height: 13))
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        subtitleLabel.textColor = .lightGray

        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(subtitleLabel)
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
