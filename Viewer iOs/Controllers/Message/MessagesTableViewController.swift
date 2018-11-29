//
//  MessagesTableViewController.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 24/10/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit
import CloudKit

class MessagesTableViewController: UITableViewController{
    
    // MARK: Variables
    let delegate = (UIApplication.shared.delegate as! AppDelegate)

    var globalMessages = [GlobalMessage](){
        didSet{
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: View Controller life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getAllMessages(with: delegate.query)
        
        refreshControl = UIRefreshControl()
        
        self.refreshControl?.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                 for: .valueChanged)
        self.refreshControl?.tintColor = .lightGray

//        if globalMessages.count == 0{
//            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
//            label.text = "Plase add new message with the + button."
//            label.translatesAutoresizingMaskIntoConstraints = false
//            label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//            label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//            tableView.alpha = 0
//            view.addSubview(label)
//        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        self.getAllMessages(with: delegate.query)
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK: TableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalMessages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as? MessagesTableViewCell{
            cell.titleLabel.text = globalMessages[indexPath.row].title
            cell.descriptionLabel.text = globalMessages[indexPath.row].description
            cell.locationLabel.text = globalMessages[indexPath.row].location
            return cell
        }
        print("Error")
        return UITableViewCell()
    }
    
    // MARK: Table View Delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let remove = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (action, indexPath) in
            
                DispatchQueue.main.async {
                    self?.globalMessages.remove(at: indexPath.row)
                    CKController.remove(globalMessage: self?.gobalMessages[indexPath.row])
                    self?.tableView.reloadData()
                }
            })
        }
        
        
        
        remove.backgroundColor = .red
        return [remove]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditMessageSegue", sender: globalMessages[indexPath.row])
    }
    
    // MARK: Private Implementation
    private func getAllMessages(with query: CKQuery){
        
        do {
            self.globalMessages = try CKController.getAllGlobalMessages(completionHandler: {
                debugPrint("Have all messages")
            })
        }catch {
            print(error.localizedDescription) //Handle connection timed out error
        }
        
        tableView.alpha = 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "EditMessageSegue":
            if let destination = segue.destination as? EditMessageViewController{
                destination.message = (sender as! GlobalMessage)
            }
            
            break
        default:
            break
        }
    }
}
