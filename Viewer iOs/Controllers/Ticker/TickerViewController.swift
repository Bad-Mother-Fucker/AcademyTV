//
//  TickerViewController.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 12/12/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

class TickerViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 235
        }else{
            return 55
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    @IBAction func saveThickerMessage(_ sender: UIBarButtonItem) {
        if let message = textField.text{
            if message != ""{
                CKController.postServiceMessage(message, forSeconds: 60*60)
            }else{
                let alert = UIAlertController(title: "Add a message to post", message: "The message to post cann't be empty", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

