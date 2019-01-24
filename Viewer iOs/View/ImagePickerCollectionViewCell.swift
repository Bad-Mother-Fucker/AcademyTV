//
//  ImagePickerCollectionViewCell.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 27/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

class ImagePickerCollectionViewCell: UICollectionViewCell {
    
    var currentImage: UIImage?{
        didSet{
            imageView.image = currentImage
        }
    }

    var isCheked: Bool?{
        didSet{
            checkerView.isHidden = isCheked ?? false
        }
    }
    
    @IBOutlet private weak var imageView: UIImageView!{
        didSet{
            imageView.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet private weak var checkerView: UIImageView!
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                checkerView.isHidden = false
            } else {
                checkerView.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.image = currentImage
    }
}
