//
//  TitleSubtitleAndDescriptionTableViewCell.swift
//  Viewer
//
//  Created by Gianluca Orpello on 29/01/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//

import UIKit

/**
 ## TableViewCell with three different information

 - Version: 1.0

 - Author: @GianlucaOrpello
 */
class TitleSubtitleAndDescriptionTableViewCell: UITableViewCell {

    /**
     ## Title of the table view cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var title: String?{
        didSet{
            titleLabel.text = title
        }
    }

    /**
     ## Subtitle of the table view cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var subtitle: String?{
        didSet{
            subtitleLabel.text = subtitle
        }
    }

    /**
     ## Description of the table view cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var descriptions: String?{
        didSet{
            descriptionLabel.text = descriptions
        }
    }

    /**
     ## Title Label of the table view cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var titleLabel: UILabel!

    /**
     ## Subtitle Label of the table view cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var subtitleLabel: UILabel!

    /**
     ## Description Label of the table view cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var descriptionLabel: UILabel!

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
        subtitleLabel = UILabel()
        descriptionLabel = UILabel()

        // Set the Title Label
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = .black

        // Set the Subtitle Label
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        subtitleLabel.textColor = .black

        // Set the description Label
        descriptionLabel.text = descriptions
        descriptionLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        descriptionLabel.textColor = .lightGray

        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(subtitleLabel)
        self.contentView.addSubview(descriptionLabel)
        addConstraints(to: titleLabel, subtitleLabel, and: descriptionLabel)
    }

    /**
     ## Required init

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
    @objc func addConstraints(to view: UIView, _ secondView: UIView, and thirdView: UIView){
        view.translatesAutoresizingMaskIntoConstraints = false
        secondView.translatesAutoresizingMaskIntoConstraints = false
        thirdView.translatesAutoresizingMaskIntoConstraints = false

        let safeArea = self.safeAreaLayoutGuide

        view.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16)
        view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -64).isActive = true
        view.bottomAnchor.constraint(equalTo: secondView.topAnchor, constant: -6).isActive = true

        secondView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        secondView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -64).isActive = true
        secondView.bottomAnchor.constraint(equalTo: thirdView.topAnchor, constant: -6).isActive = true

        thirdView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        thirdView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -64).isActive = true
        thirdView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16).isActive = true

        self.layoutIfNeeded()
    }
}
