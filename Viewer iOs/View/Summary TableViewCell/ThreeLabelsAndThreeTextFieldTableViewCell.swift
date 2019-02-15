//
//  ThreeLabelsAndThreeTextFieldTableViewCell.swift
//  Viewer
//
//  Created by Gianluca Orpello on 12/02/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//

import UIKit

/**
 ## Table View Cell with three label and three textField

 - Version: 1.0

 - Author: @GianlucaOrpello
 */
class ThreeLabelsAndThreeTextFieldTableViewCell: UITableViewCell {

    /**
     ## The first title

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var firstTitle: String?{
        didSet{
            firstLabel.text = firstTitle
        }
    }

    /**
     ## The second title

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var secondTitle: String?{
        didSet{
            secondLabel.text = secondTitle
        }
    }

    /**
     ## The third title

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var thirdTitle: String?{
        didSet{
            thirdLabel.text = thirdTitle
        }
    }

    /**
     ## The first text of the textfield

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var firstText: String?{
        didSet{
            firstTextField.text = firstText
        }
    }

    /**
     ## The second text of the textfield

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var secondText: String?{
        didSet{
            secondTextField.text = secondText
        }
    }

    /**
     ## The third text of the textfield

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var thirdText: String?{
        didSet{
            thirdTextField.text = thirdText
        }
    }

    /**
     ## Delegate

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var delegate: UITextFieldDelegate?{
        didSet{
            firstTextField.delegate = delegate
            secondTextField.delegate = delegate
//            thirdTextField.delegate = delegate
        }
    }

    /**
     ## Delegate

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var isCheckoutMode: Bool = true{
        didSet{
            if isCheckoutMode {
                thirdTextField.isEditable = false
                thirdTextField.isSelectable = false
            } else {
                thirdTextField.isEditable = true
                thirdTextField.isSelectable = true
            }
        }
    }

    /**
     ## The color of the textfields

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var textfieldTextColor: UIColor?{
        didSet{
            firstTextField.textColor = textfieldTextColor
            secondTextField.textColor = textfieldTextColor
            thirdTextField.textColor = textfieldTextColor
        }
    }

    /**
     ## The first label of the cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var firstLabel: UILabel!

    /**
     ## The second label of the cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var secondLabel: UILabel!

    /**
     ## The third label of the cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var thirdLabel: UILabel!

    /**
     ## The first textField of the cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var firstTextField: UITextField!

    /**
     ## The second textField of the cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var secondTextField: UITextField!

    /**
     ## The third textField of the cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var thirdTextField: UITextView!

    /**
     ## initializer

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

        firstLabel = UILabel()
        secondLabel = UILabel()
        thirdLabel = UILabel()

        firstLabel.text = firstTitle
        secondLabel.text = secondTitle
        thirdLabel.text = thirdTitle

        firstLabel.font = UIFont.systemFont(ofSize: 17)
        secondLabel.font = UIFont.systemFont(ofSize: 17)
        thirdLabel.font = UIFont.systemFont(ofSize: 17)

        firstTextField = UITextField()
        secondTextField = UITextField()
        thirdTextField = UITextView()

        firstTextField.font = UIFont.systemFont(ofSize: 16)
        secondTextField.font = UIFont.systemFont(ofSize: 16)
        thirdTextField.font = UIFont.systemFont(ofSize: 16)

        firstTextField.delegate = delegate
        secondTextField.delegate = delegate
//        thirdTextField.delegate = delegate

        firstTextField.text = firstTitle
        secondTextField.text = secondTitle
        thirdTextField.text = thirdTitle

        firstTextField.tag = 503
        secondTextField.tag = 504
        thirdTextField.tag = 505

        firstTextField.textColor = textfieldTextColor
        secondTextField.textColor = textfieldTextColor
        thirdTextField.textColor = textfieldTextColor

        if isCheckoutMode {
            thirdTextField.isEditable = false
            thirdTextField.isSelectable = false
        } else {
            thirdTextField.isEditable = true
            thirdTextField.isSelectable = true
        }

        self.contentView.addSubview(firstLabel)
        self.contentView.addSubview(secondLabel)
        self.contentView.addSubview(thirdLabel)
        self.contentView.addSubview(firstTextField)
        self.contentView.addSubview(secondTextField)
        self.contentView.addSubview(thirdTextField)
        addConstraints()
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
    @objc func addConstraints(){

        let safeArea = self.safeAreaLayoutGuide

        func addSimpleConstraints(from view: UIView, to secondView: UIView){
            view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
            view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 89).isActive = true
            view.bottomAnchor.constraint(equalTo: secondView.topAnchor, constant: -5).isActive = true
        }

        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        thirdLabel.translatesAutoresizingMaskIntoConstraints = false

        firstTextField.translatesAutoresizingMaskIntoConstraints = false
        secondTextField.translatesAutoresizingMaskIntoConstraints = false
        thirdTextField.translatesAutoresizingMaskIntoConstraints = false


        firstLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10).isActive = true
        firstLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
        firstLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 89).isActive = true
        firstLabel.bottomAnchor.constraint(equalTo: firstTextField.topAnchor, constant: 0).isActive = true

        addSimpleConstraints(from: firstTextField, to: secondLabel)
        addSimpleConstraints(from: secondLabel, to: secondTextField)
        addSimpleConstraints(from: secondTextField, to: thirdLabel)
        addSimpleConstraints(from: thirdLabel, to: thirdTextField)

        firstLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        secondLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        thirdLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true

        thirdTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
        thirdTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 89).isActive = true
        thirdTextField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10).isActive = true

        self.layoutIfNeeded()
    }
}
