//
//  ImagePickerCollectionViewCell.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 27/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

class ImagePickerCollectionViewCell: UICollectionViewCell {
    
    var image: UIImage?{
        didSet{
            imageView.image = image
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!{
        didSet{
            imageView.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet weak var checkerView: UIImageView!
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                checkerView.isHidden = false
            }else{
                checkerView.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.image = image
    }
}
