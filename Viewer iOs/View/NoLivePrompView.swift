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
    var bigTitleLabel: UILabel!
    
    /**
     ## Subtitle Label
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var subTitleLabel: UILabel!
    
    /**
     ## Action for report a problem.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var contactbutton: UIButton!
    
    
    /**
     ## Set the information of the views.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    private func set(){
        
        bigTitleLabel.text = "No live props"
        bigTitleLabel.textColor = .lightGray
        bigTitleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        bigTitleLabel.textAlignment = .center
        
        subTitleLabel.text = "Tap on the + icon to air a new prop on the TV"
        subTitleLabel.textColor = .lightGray
        subTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subTitleLabel.textAlignment = .center
        
        contactbutton.setTitle("Something's wrong?", for: .normal)
        contactbutton.setTitleColor(UIColor(red: 0, green: 119 / 255, blue: 1, alpha: 1), for: .normal)
    }
    
    /**
     ## UIView - Init with frame
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bigTitleLabel = UILabel(frame: CGRect(x: 20, y: 419, width: 375, height: 29))
        subTitleLabel = UILabel(frame: CGRect(x: 50, y: 457, width: 315, height: 20))
        contactbutton = UIButton(frame: CGRect(x: 0, y: 819, width: 414, height: 60))
        
        set()
        
        self.addSubview(bigTitleLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(contactbutton)
    }
    
    /**
     ## UIView - Init with coder
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        bigTitleLabel = UILabel(frame: CGRect(x: 20, y: 419, width: 375, height: 29))
        subTitleLabel = UILabel(frame: CGRect(x: 50, y: 457, width: 315, height: 20))
        contactbutton = UIButton(frame: CGRect(x: 0, y: 819, width: 414, height: 60))
        
        set()
        
        self.addSubview(bigTitleLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(contactbutton)
    }
}
