//
//  GroupsCollectionViewCell.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 10/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

/// This class are used for rappresent the TV Groups Collection View Cell
class GroupsCollectionViewCell: UICollectionViewCell {

    // MARK: - Public API

    var groupName: String?{
        didSet{
            groupNameLabel.text = groupName
        }
    }

    // MARK: - Outlets

    /**
     UIView - The outlet linked to the title of the cell.
     */

    @IBOutlet private weak var gradientView: UIView!

    /**
     UIButton - The outlet linked to the option button.

     - Attention: We have to finish to implement this for select inividual tvs
     */
    @IBOutlet private weak var optionButton: UIButton!{
        didSet{
            optionButton.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            optionButton.layer.cornerRadius = optionButton.frame.width / 2
            optionButton.clipsToBounds = true
        }
    }

    /**
     UIImageView - The outlet linked to the "check" image.
     */
    @IBOutlet private weak var checkMarkImageView: UIImageView!

    /**
     UILabel - The outlet linked to the title of the group name cell.
     */
    @IBOutlet private weak var groupNameLabel: UILabel!

    /**
     Bool - Control the selection state of the cell.
     */
    override var isSelected: Bool{
        didSet{
            if isSelected{
                checkMarkImageView.image = UIImage(named: "Checked")
            } else {
                checkMarkImageView.image = nil
            }
        }
    }

    // MARK: - View Controller Life Cycle

    /**
     Override the default awakeFromNib.

     We use this for set the basic layout information of the cell
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }

    // MARK: - Public Function

    /**
     Creates a gradient color starting from the left to the right inside the view.

     - Parameters:
        - startingColor: The starting color of the gradient.
        - endingColor: The ending color of the gradient.

    */
    func setGradientBackground(form startingColor: UIColor, to endingColor: UIColor) {

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startingColor.cgColor, endingColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = self.contentView.bounds

        self.gradientView.layer.addSublayer(gradientLayer)
    }
}
