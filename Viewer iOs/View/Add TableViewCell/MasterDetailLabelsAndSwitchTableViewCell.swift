//
//  MasterDetailLabelsAndSwitchTableViewCell.swift
//  Viewer
//
//  Created by Gianluca Orpello on 05/02/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//

import UIKit

/**
 ## Master Detail Labels And Switch TableViewCell

 - Version: 1.0

 - Author: @GianlucaOrpello
 */
class MasterDetailLabelsAndSwitchTableViewCell: UITableViewCell {

    /**
     ## Main Text

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
     ## Is the Switch On

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var isSwitchOn: Bool?{
        didSet{
            mainSwitch.isOn = isSwitchOn ?? false
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
     sa
     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var detailLabel: UILabel!{
        didSet{
            addConstraints(to: detailLabel)
        }
    }

    /**
     ## Main Switch
     sa
     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var mainSwitch: UISwitch!{
        didSet{
            addConstraints(to: mainSwitch)
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

        mainLabel = UILabel(frame: CGRect(x: 16, y: (self.frame.height / 2) - 10, width: 100, height: 22))
        mainLabel.text = mainText

        detailLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width - 225, y: (self.frame.height / 2) - 11, width: 150, height: 22))

        mainSwitch = UISwitch(frame: CGRect(x: UIScreen.main.bounds.width - 65, y: 10, width: 55, height: 36))

        mainSwitch.isOn = isSwitchOn ?? false

        detailLabel.numberOfLines = 0
        detailLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        detailLabel.textAlignment = .right
        detailLabel.tag = 500

        self.contentView.addSubview(mainLabel)
        self.contentView.addSubview(detailLabel)
        self.contentView.addSubview(mainSwitch)
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
     ## Add Action to the Switch

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func addTarget(_ controller: UIViewController, action: Selector){
        if mainSwitch != nil{
            mainSwitch.addTarget(controller, action: action, for: .valueChanged)
        }
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
