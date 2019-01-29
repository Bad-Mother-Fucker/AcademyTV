//
//  CenteredButtonTableViewCell.swift
//  Viewer
//
//  Created by Gianluca Orpello on 29/01/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//

import UIKit

/**
 ## Table View Cell with centered button

 - Version: 1.0

 - Author: @GianlucaOrpello
 */
class CenteredButtonTableViewCell: UITableViewCell {

    /**
     ## The title of the button

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var title: String?{
        didSet{
            button.setTitle(title, for: .normal)
        }
    }

    /**
     ## The title color of the button

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var titleColor: UIColor?{
        didSet{
            button.setTitleColor(titleColor, for: .normal)
        }
    }

    /**
     ## The button of the cell

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private var button: UIButton!

    /**
     ## initializer

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none

        button = UIButton(frame: CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 40))

        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)

        self.contentView.addSubview(button)
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
     ## Add Action to the button

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func addTarget(_ controller: UIViewController, action: Selector){
        if button != nil{
            button.addTarget(controller, action: action, for: .touchDragInside)
        }
    }
}
