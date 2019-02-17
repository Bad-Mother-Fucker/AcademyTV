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
     ## StackView

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var stack: UIStackView!
    
    
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
        
        bigTitleLabel = UILabel()
        subTitleLabel = UILabel()
        contactbutton = UIButton()

        stack = UIStackView(arrangedSubviews: [bigTitleLabel, subTitleLabel])
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 10
        
        set()
        
        self.addSubview(stack)
        self.addSubview(contactbutton)
        addConstraints()
    }
    
    /**
     ## UIView - Init with coder
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /**
     ## Add Constraints

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    @objc func addConstraints(){
        bigTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contactbutton.translatesAutoresizingMaskIntoConstraints = false

        let safeArea = self.safeAreaLayoutGuide

        stack.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0)
        contactbutton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0)

        stack.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: 0)

        contactbutton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: 0)
        contactbutton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16).isActive = true

        self.layoutIfNeeded()
    }
}
