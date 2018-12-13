//
//  PosterViewController.swift
//  Viewer
//
//  Created by Gianluca Orpello on 14/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
    let props: [(title: String, description: String, image: UIImage?)] = [
        (title: "Booqable Availability", description: "Displays a list of names that are overdue, on hold and ready for pickup", image: UIImage(named: "Booquable")),
        (title: "Global Message", description: "Displays a message with title, description, date & time, location and URL", image: UIImage(named: "GlobalMessage")),
        (title: "Ticker", description: "Displays a short messager always visibile at the bottom of the screen", image: UIImage(named: "Ticker")),
        (title: "Keynote", description: "Dislays a keynote on selected area, airplay is not needed", image: UIImage(named: "Keynote"))
    ]
    
    private let identifier = "PropsTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.tableFooterView = UIView()
        
        let userDefault = UserDefaults.standard
        userDefault.addSuite(named: "com.Rogue.Viewer.ShareExt")
        
        if let dict = userDefault.value(forKey: "keynote") as? [String:Any]{
            
            let data = dict["imgData"] as! [Data]
            let str = dict["name"] as! String
            print(data,str)
            userDefault.removeObject(forKey: "img")
            userDefault.synchronize()
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return props.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PropsTableViewCell
        
        let prop = props[indexPath.row]
        cell.leftImageView.image = prop.image
        cell.titleLabel.text = prop.title
        cell.descriptionLabel.text = prop.description
        
        return  cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "showBooquableLateDeviceSegue", sender: nil)
            break
        case 1:
            performSegue(withIdentifier: "postGlobalMessageSegue", sender: nil)
            break
        case 2:
            performSegue(withIdentifier: "ThickerMessageSegue", sender: nil)
            break
        case 3:
            performSegue(withIdentifier: "postKeynoteSegue", sender: nil)
            break
        default:
            break
        }
    }
    
}
