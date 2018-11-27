//
//  MessagesTableViewController.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 24/10/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit
import CloudKit

class MessagesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    // MARK: Outlet
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
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
        
        tableView.alpha = 0
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) {[weak self] (timer) in
            self?.getAllMessages(with: (self?.delegate.query)!)
        }
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
    
    // MARK: TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let remove = UITableViewRowAction(style: .destructive, title: "Cancel") {[weak self] (action, indexPath) in
            self?.delegate.database.delete(withRecordID: (self?.globalMessages[indexPath.row].record.recordID)!, completionHandler: { (record, error) in
                guard error == nil else{
                    print(error.debugDescription)
                    return
                }
                DispatchQueue.main.async {
                    self?.globalMessages.remove(at: indexPath.row)
                    self?.tableView.reloadData()
                }
            })
        }
        remove.backgroundColor = .red
        return [remove]
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
}
