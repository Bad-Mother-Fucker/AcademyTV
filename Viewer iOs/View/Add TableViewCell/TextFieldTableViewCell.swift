//
//  TextFieldTableViewCell.swift
//  Viewer.iOS
//
//  Created by Gianluca Orpello on 31/01/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//

import UIKit

/**
 ## TextField TableViewCell

 - Version: 1.0

 - Author: @GianlucaOrpello
 */
class TextFieldTableViewCell: UITableViewCell {

    /**
     ## Placeholder Text

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var placeholderText: String?{
        didSet{
            textField.text = placeholderText
        }
    }

    /**
     ## Delegate

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var delegate: UITextFieldDelegate?{
        didSet{
            textField.delegate = delegate
        }
    }

    /**
     ## Text Field

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var textField: UITextField!{
        didSet{
            addConstraints(to: textField)
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

        textField = UITextField(frame: CGRect(x: 16, y: (self.frame.height / 2) - 10, width: UIScreen.main.bounds.width - 32, height: 36))

        textField.delegate = delegate
        textField.borderStyle = .none
        textField.placeholder = placeholderText
        textField.tag = 500

        self.contentView.addSubview(textField)

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
