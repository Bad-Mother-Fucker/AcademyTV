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
    case KeynoteViewer = "Content Viewer"
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
     ## All the keynote airing.
     
     - Todo: Try to pass this information inside all the application.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var keynote: [(image: [UIImage]?, tvName: String)]? = nil
    
    /**
     ## UIVIewController - View did Load Methods
     
     - Version: 1.1
     
     - Author: @GianlucaOrpello
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thikerMessage = CKController.getAiringTickers(in: .all)
        keynote = CKController.getAiringKeynote(in: .all)
        
        do{
            globalMessages = try CKController.getAllGlobalMessages(completionHandler: {
                self.numberOfObject = 1
            })
        }catch{
            print("Error getting the messages.")
            numberOfObject = 0
        }
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
            tableView.tintColor = UIColor(red: 0, green: 119/255, blue: 1, alpha: 1)

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
        switch indexPath.section {
        case 0, 2:
            return 95
        case 1:
            return 73
        default:
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

            let alert = UIAlertController(title: "Delete Prop", message: "The prop will be removed from all the screens. This cannot be undone.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let delete = UIAlertAction(title: "Delete", style: .cancel, handler: { [weak self] (action) in

                switch indexPath.section{
                case 0:
                    CKController.removeTickerMessage(fromTVNamed: (self?.thikerMessage![indexPath.row].tvName)!)
                    break
                case 1:
                    CKController.removeKeynote(FromTV: (self?.keynote![indexPath.row].tvName)!)
                    break
                case 2:
                    CKController.remove(globalMessage: (self?.globalMessages![indexPath.row])!)
                    break
                default:
                    break
                }
                
                tableView.reloadData()
            })
            
            alert.addAction(cancel)
            alert.addAction(delete)
            
            self?.present(alert, animated: true, completion: nil)
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
        let destination = SummaryViewController()
        let nav = UINavigationController(rootViewController: destination)
        nav.navigationBar.prefersLargeTitles = true
        
        destination.prop = getProp(from: indexPath)
        
        self.present(nav, animated: true, completion: nil)
    }
    
    /**
     ## Get the prop of the table view cell with the indexPath.
     
     - Parameters:
        - indexPath: The current indexPath of the TableView.
     
     - Return: The element that is inside the cell.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    private func getProp(from indexPath: IndexPath) -> Any?{
        switch indexPath.section {
        case 0:
            return thikerMessage?[indexPath.row]
        case 1:
            return keynote?[indexPath.row]
        case 2:
            return globalMessages?[indexPath.row]
        default:
            return nil
        }
    }
    
    // MARK: - UITableView Data Source
    
    /**
     ## UITableViewDataSource - numberOfSections Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
            return keynote?.count ?? 0
        case 2:
            return globalMessages?.count ?? 0
        case 3:
            return 1
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
            cell.selectionStyle = .none
            
            let titleLabel = UILabel(frame: CGRect(x: 16, y: 16, width: 350, height: 44))
            
            titleLabel.text = thikerMessage?[indexPath.row].message
            titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            titleLabel.textColor = .black
            
            let subtitleLabel = UILabel(frame: CGRect(x: 16, y: 66, width: 350, height: 13))
            
            subtitleLabel.text = thikerMessage?[indexPath.row].tvName
            subtitleLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
            subtitleLabel.textColor = .lightGray
            
            cell.contentView.addSubview(titleLabel)
            cell.contentView.addSubview(subtitleLabel)
            
            return cell
            
        case 1:
            
            let cell = UITableViewCell()
            cell.accessoryType = .detailButton
            cell.selectionStyle = .none
            
            let titleLabel = UILabel(frame: CGRect(x: 16, y: 16, width: 350, height: 22))
            
            titleLabel.text = "Unnamed"
            titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            titleLabel.textColor = .black
            
            let subtitleLabel = UILabel(frame: CGRect(x: 16, y: 44, width: 350, height: 13))
            
            subtitleLabel.text = keynote?[indexPath.row].tvName
            subtitleLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
            subtitleLabel.textColor = .lightGray
            
            cell.contentView.addSubview(titleLabel)
            cell.contentView.addSubview(subtitleLabel)
            
            return cell
            
        case 2:
            
            let cell = UITableViewCell()
            cell.accessoryType = .detailButton
            cell.selectionStyle = .none
            
            let titleLabel = UILabel(frame: CGRect(x: 16, y: 16, width: 350, height: 22))
            
            titleLabel.text = globalMessages?[indexPath.row].title
            titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            titleLabel.textColor = .black
            
            let subtitleLabel = UILabel(frame: CGRect(x: 16, y: 38, width: 350, height: 22))
            
            subtitleLabel.text = globalMessages?[indexPath.row].subtitle
            subtitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            subtitleLabel.textColor = .black
            
            let locationLabel = UILabel(frame: CGRect(x: 16, y: 66, width: 350, height: 13))
            
            locationLabel.text = "Everywhere"
            locationLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
            locationLabel.textColor = .lightGray
            
            cell.contentView.addSubview(titleLabel)
            cell.contentView.addSubview(subtitleLabel)
            cell.contentView.addSubview(locationLabel)
            
            return cell
            
        case 3:
            
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            tableView.separatorStyle = .none
            
            let button = UIButton(frame: CGRect(x: 0, y: 10, width: 414, height: 40))
            
            button.setTitle("Something's wrong?", for: .normal)
            button.setTitleColor(UIColor(red: 0, green: 119/255, blue: 1, alpha: 1), for: .normal)
            button.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
            
            cell.contentView.addSubview(button)
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    
}
