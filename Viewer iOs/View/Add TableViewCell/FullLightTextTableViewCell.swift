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

        label = UILabel(frame: CGRect(x: 16, y: (self.contentView.bounds.height / 2) - 10, width: UIScreen.main.bounds.width - 32, height: self.frame.height))

        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .lightGray
        label.text = fullText

        self.contentView.addSubview(label)
        
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
    private func addConstraints(to view: UIView){
        view.translatesAutoresizingMaskIntoConstraints = false

        let topConstraint = NSLayoutConstraint(item: view,
                                                      attribute: .top,
                                                      relatedBy: .equal,
                                                      toItem: self.backgroundView,
                                                      attribute: .top,
                                                      multiplier: 1,
                                                      constant: 16)

        let rightConstraint = NSLayoutConstraint(item: view,
                                                    attribute: .right,
                                                    relatedBy: .equal,
                                                    toItem: self.backgroundView,
                                                    attribute: .right,
                                                    multiplier: 1,
                                                    constant: 16)

        let bottomConstraint = NSLayoutConstraint(item: view,
                                                 attribute: .bottom,
                                                 relatedBy: .equal,
                                                 toItem: self.backgroundView,
                                                 attribute: .bottom,
                                                 multiplier: 1,
                                                 constant: 16)

        let leftConstraint = NSLayoutConstraint(item: view,
                                                  attribute: .left,
                                                  relatedBy: .equal,
                                                  toItem: self.backgroundView,
                                                  attribute: .left,
                                                  multiplier: 1,
                                                  constant: 16)

        view.addConstraints([topConstraint, rightConstraint, bottomConstraint, leftConstraint])
        view.layoutIfNeeded()
    }
}
