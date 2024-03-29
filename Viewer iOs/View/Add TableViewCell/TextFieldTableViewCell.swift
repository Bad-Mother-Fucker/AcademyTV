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
            textField.placeholder = placeholderText
        }
    }

    /**
     ## Text Color

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var colorText: UIColor?{
        didSet{
            textField.textColor = colorText
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

        textField = UITextField()

        textField.delegate = delegate
        textField.borderStyle = .none
        textField.placeholder = placeholderText
        textField.textColor = colorText ?? .lightGray
        textField.tag = 500

        self.contentView.addSubview(textField)
        addConstraintsWithSafeArea(to: textField)
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
