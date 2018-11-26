//
//  GroupsCollectionViewCell.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 10/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

class GroupsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var optionButton: UIButton!{
        didSet{
            optionButton.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            optionButton.layer.cornerRadius = optionButton.frame.width/2
            optionButton.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var checkMarkImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                checkMarkImageView.image = UIImage(named: "Checked")
            }else{
                checkMarkImageView.image = nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    func setGradientBackground(form startingColor: UIColor, to endingColor: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startingColor.cgColor, endingColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = self.contentView.bounds
        
        self.gradientView.layer.addSublayer(gradientLayer)
    }
}
