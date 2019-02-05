//
//  LabelAndTextfieldTableViewCell.swift
//  Viewer.iOS
//
//  Created by Gianluca Orpello on 31/01/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//

import UIKit

/**
 ## Label And Textfield TableViewCell

 - Version: 1.0

 - Author: @GianlucaOrpello
 */
class LabelAndTextfieldTableViewCell: UITableViewCell {

    /**
     ## Title

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var titleText: String?{
        didSet{
            label.text = titleText
        }
    }

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
            textField.text = placeholderText
        }
    }

    /**
     ## Label

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var label: UILabel!{
        didSet{
            addConstraints(to: label)
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

        label = UILabel(frame: CGRect(x: 16, y: 10, width: 100, height: 22))
        label.text = titleText

        textField = UITextField(frame: CGRect(x: UIScreen.main.bounds.width - 167, y: (self.frame.height / 2) - 10, width: 157, height: 22))

        textField.delegate = delegate
        textField.borderStyle = .none
        textField.textColor = .lightGray
        textField.placeholder = placeholderText
        textField.tag = 500

        self.contentView.addSubview(label)
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
