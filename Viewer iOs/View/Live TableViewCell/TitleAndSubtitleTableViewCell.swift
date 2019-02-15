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
class TitleAndSubtitleTableViewCell: UITableViewCell {

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

        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .black

        subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        subtitleLabel.textColor = .lightGray

        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(subtitleLabel)
        addConstraints(between: titleLabel, and: subtitleLabel)
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
    @objc func addConstraints(between view: UIView, and secondView: UIView){
        view.translatesAutoresizingMaskIntoConstraints = false
        secondView.translatesAutoresizingMaskIntoConstraints = false

        let safeArea = self.safeAreaLayoutGuide

        view.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16)
        view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -64).isActive = true
        view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        view.bottomAnchor.constraint(equalTo: secondView.topAnchor, constant: -6).isActive = true
        view.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.4).isActive = true

        secondView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        secondView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -64).isActive = true
        secondView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16).isActive = true

        self.layoutIfNeeded()
    }
}
