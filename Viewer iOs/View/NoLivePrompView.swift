//
//  NoLivePrompView.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 12/01/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//

import UIKit

/**
 ## The UIView dedicated to display the text.
 
 - Version: 1.0
 
 - Author: @GianlucaOrpello
 */
class NoLivePrompView: UIView {

    /**
     ## Title Lablel
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var titleLabel = UILabel(frame: CGRect(x: 20, y: 419, width: 375, height: 29)){
        didSet{
            titleLabel.text = "No live props"
            titleLabel.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
            titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        }
    }
    
    /**
     ## Subtitle Label
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var subTitleLabel = UILabel(frame: CGRect(x: 50, y: 457, width: 315, height: 20)){
        didSet{
            titleLabel.text = "Tap on the + icon to air a new prop on the TV"
            titleLabel.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
            titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
    }
    
    /**
     ## Action for report a problem.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var contactbutton = UIButton(frame: CGRect(x: 0, y: 819, width: 414, height: 60)){
        didSet{
            contactbutton.setTitle("Something's wrong?", for: .normal)
        }
    }
    
    /**
     ## UIView - Init with frame
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(contactbutton)
    }
    
    /**
     ## UIView - Init with coder
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    required init?(coder aDecoder: NSCoder) {
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(contactbutton)
    }
}
