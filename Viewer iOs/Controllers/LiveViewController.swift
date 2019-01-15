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
class LiveViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
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
            
        })
        print(thikerMessage?.count)
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
            let noLiveView = NoLivePrompView(frame: CGRect(x: 0, y: 0, width: 414, height: 896))
            noLiveView.contactbutton.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
            self.view.addSubview(noLiveView)
        }else{
            for views in self.view.subviews{
                views.removeFromSuperview()
            }
            let tableView = UITableView(frame: self.view.frame)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
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
            mail.setSubject("Viewer: Problem on execution.")
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
    
    /**
     ## UITableViewDelegate - heightForRowAt Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != 5 {
            return 95
        }else{
            return 60
        }
    }
    
    /**
     ## UITableViewDelegate - editActionsForRowAt Methods
     
     - Todo: Remove the selected data from CK
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let remove = UITableViewRowAction(style: .destructive, title: "Delete") {
            [weak self] (action, indexPath) in

            tableView.reloadData()
            
        }
        
        remove.backgroundColor = .red
        return [remove]
    }
    
    /**
     ## UITableViewDelegate - titleForHeaderInSection Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return Categories.ThikerMessage.rawValue
        case 1:
            return Categories.KeynoteViewer.rawValue
        case 2:
            return Categories.KeynoteViewer.rawValue
        case 3:
            return Categories.GlobalMessage.rawValue
        default:
            return nil
        }
    }
    
    /**
     ## UITableViewDelegate - accessoryButtonTappedForRowWith Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
    }
    
    // MARK: - UITableView Data Source
    
    /**
     ## UITableViewDataSource - numberOfSections Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    /**
     ## UITableViewDataSource - numberOfRowsInSection Methods
     
     - Todo: Add the minnsing information fro keynote and timer
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return thikerMessage?.count ?? 0
        case 1:
            return 0
        case 2:
            return 0
        case 3:
            return globalMessages?.count ?? 0
        default:
            return 0
        }
    }
    
    /**
     ## UITableViewDataSource - cellForRowAt Methods
     
     - Todo: Add the other cell
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            
            let cell = UITableViewCell()
            cell.accessoryType = .detailButton
            
            var titleLabel = UILabel(frame: CGRect(x: 16, y: 16, width: 350, height: 44)){
                didSet{
                    titleLabel.text = thikerMessage?[indexPath.row].message
                    titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
                    titleLabel.textColor = .black
                }
            }
            
            var subtitleLabel = UILabel(frame: CGRect(x: 16, y: 66, width: 350, height: 13)){
                didSet{
                    subtitleLabel.text = thikerMessage?[indexPath.row].tvName
                    subtitleLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
                    titleLabel.textColor = .lightGray
                }
            }
            
            cell.contentView.addSubview(titleLabel)
            cell.contentView.addSubview(subtitleLabel)
            
            return cell
            
        case 3:
            
            let cell = UITableViewCell()
            cell.accessoryType = .detailButton
            
            var titleLabel = UILabel(frame: CGRect(x: 16, y: 16, width: 350, height: 22)){
                didSet{
                    titleLabel.text = globalMessages?[indexPath.row].title
                    titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
                    titleLabel.textColor = .black
                }
            }
            
            var subtitleLabel = UILabel(frame: CGRect(x: 16, y: 38, width: 350, height: 22)){
                didSet{
                    subtitleLabel.text = globalMessages?[indexPath.row].subtitle
                    subtitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
                    titleLabel.textColor = .black
                }
            }
            
            var locationLabel = UILabel(frame: CGRect(x: 16, y: 66, width: 350, height: 13)){
                didSet{
                    subtitleLabel.text = "Everywhere"
                    subtitleLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
                    titleLabel.textColor = .lightGray
                }
            }
            
            cell.contentView.addSubview(titleLabel)
            cell.contentView.addSubview(subtitleLabel)
            cell.contentView.addSubview(locationLabel)
            
            return cell
            
        case 5:
            
            let cell = UITableViewCell()
            
            var button = UIButton(frame: CGRect(x: 0, y: 0, width: 350, height: 60)){
                didSet{
                    button.setTitle("Something's wrong?", for: .normal)
                    button.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
                }
            }
            
            cell.contentView.addSubview(button)
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    
}
