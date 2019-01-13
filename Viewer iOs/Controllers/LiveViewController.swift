//
//  LiveViewController.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 12/01/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//

import UIKit
import MessageUI

/**
 ## List of categories section of the table view.
 
 - Version: 1.0
 
 - Author: @GianlucaOrpello
 */
enum Categories: String{    
    case ThikerMessage = "Ticker Messages"
    case KeynoteViewer = "Keynote Viewer"
    case Timer = "Timer"
    case GlobalMessage = "Global Messages"
}

/**
 ## The Home screen view controller.
 
 - Version: 1.1
 
 - Author: @GianlucaOrpello
 */
class LiveViewController: UIViewController {
    
    /**
     ## Number of item of the table view

     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var numberOfObject: Int = 0
    
    /**
     ## All the global message airing.
    
     - Todo: Try to pass this information inside all the application.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var globalMessages: [GlobalMessage]? = nil
    
    /**
     ## All the thicker message airing.
     
     - Todo: Try to pass this information inside all the application.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var thikerMessage: [(message: String, tvName: String)]? = nil
    
    /**
     ## UIVIewController - View did Load Methods
     
     - Version: 1.1
     
     - Author: @GianlucaOrpello
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thikerMessage = CKController.getAiringTickers(in: .all)
        
        globalMessages = try? CKController.getAllGlobalMessages(completionHandler: {
            self.viewDidAppear(true)
        })
        
    }
    
    /**
     ## UIVIewController - ViewDidAppear Methods
     
     Used for add the object inside the view.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if numberOfObject == 0{
            let noLiveView = NoLivePrompView(frame: CGRect(x: 20, y: 419, width: 375, height: 58))
            noLiveView.contactbutton.addTarget(self, action: #selector(sendEmail), for: .normal)
            self.view.addSubview(noLiveView)
        }else{
            for views in self.view.subviews{
                views.removeFromSuperview()
            }
            let tableView = UITableView(frame: self.view.frame)
            tableView.delegate = self
            tableView.dataSource = self
            self.view.addSubview(tableView)
        }
    }
    
    /**
     ## Send an email for report a problem
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @objc func sendEmail(){
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["g.orpello@gmail.com"])
            mail.setMessageBody("<p>There is an error inside Viewer app.</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: "Ops...", message: "There is an error with the network, please contact a manager.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

/**
 ## LiveViewController - Inplement the Table View delegate and datasource.
 
 - Version: 1.0
 
 - Author: @GianlucaOrpello
 */
extension LiveViewController: UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let remove = UITableViewRowAction(style: .destructive, title: "Delete") {
            [weak self] (action, indexPath) in

            tableView.reloadData()
            
        }
        
        remove.backgroundColor = .red
        return [remove]
    }
    
    // MARK: - UITableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
