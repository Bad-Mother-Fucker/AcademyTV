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
            textField.delegate = delegate
        }
    }

    /**
     ## Label

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var label: UILabel!{
        didSet{
            addConstraintsWithSafeArea(to: label)
        }
    }


    /**
     ## Text Field

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var textField: UITextField!{
        didSet{
            addConstraintsWithSafeArea(to: textField)
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
        label.text = titleText

        textField = UITextField()

        textField.delegate = delegate
        textField.borderStyle = .none
        textField.textColor = .lightGray
        textField.placeholder = placeholderText
        textField.textAlignment = .right
        textField.tag = 500

        self.contentView.addSubview(label)
        self.contentView.addSubview(textField)
        addHorizontalConstraints(between: label, and: textField)
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
