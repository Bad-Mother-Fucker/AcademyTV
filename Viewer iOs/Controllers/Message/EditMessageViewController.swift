//
//  ViewController.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 15/10/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit
import CloudKit

class EditMessageViewController: UITableViewController, UITextFieldDelegate {
    
    var record: CKRecord!
    var message: GlobalMessage?{
        didSet{
            if let someMessage = message{
                if self.tableView != nil{
                    textFields[0].text = someMessage.title
                    textFields[1].text = someMessage.subtitle
                    textFields[3].text = someMessage.location
                    textFields[2].text = someMessage.url?.absoluteString
                    descriptionTextView.text = someMessage.description
                }
            }
        }
    }
    
    var datePickerIsVisible = false
    
    // MARK: - Outlet
    @IBOutlet var textFields: [UITextField]!{
        didSet{
            textFields.forEach { (textField) in
                textField.delegate = self
                textField.autocapitalizationType = .sentences
            }
        }
    }
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!{
        didSet{
            datePicker.datePickerMode = .dateAndTime
            datePicker.addTarget(self, action: #selector(dateDidChange(sender:)), for: .valueChanged)
        }
    }
    
    // MARK: - ViewController lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let message = self.message {
            self.title = "Edit Message"
        }else {
            self.title = "New Message"
        }
        
        

        self.tableView.tableHeaderView = UIView()
    }
    
    @objc func dateDidChange(sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        self.dateLabel.text = dateFormatter.string(from: sender.date)
    }
    
    // MARK: - Private implementation
    @IBAction func sendMessageButtonPressed(_ sender: Any) {
        sendMessage()
    }
    
    @objc func sendMessage() {
        if let message = self.message {
            record = message.record
        }else {
            record = CKRecord(recordType: GlobalMessage.recordType)
        }
        
        
        record["title"] = textFields[0].text! as CKRecordValue
        record["subtitle"] = textFields[1].text! as CKRecordValue
        record["location"] = textFields[3].text! as CKRecordValue
        record["url"] = textFields[2].text! as CKRecordValue
        record["date"] = dateLabel.text! as CKRecordValue
        record["description"] = descriptionTextView.text! as CKRecordValue
        
        if let message = self.message {
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }else {
            CKController.postMessage(title: textFields[0].text!,
                                     subtitle: textFields[1].text!,
                                     location: textFields[3].text!,
                                     description: descriptionTextView.text!,
                                     URL: URL(string: textFields[2].text!),
                                     timeToLive: 5)
        }
        
        
        
        
        
        let alert: UIAlertController = UIAlertController(title: "Success",
                                                         message: "Message saved correctly",
                                                         preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .cancel, handler: { (alert) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func toggleShowDateDatepicker () {
        datePickerIsVisible = !datePickerIsVisible
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            return 3
        }else if section == 0 || section == 1{
            return 2
        }else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        if section == 1{
            let footer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
            footer.backgroundColor = .clear
            let label = UILabel(frame: CGRect(x: 16, y: 0, width: self.view.frame.width - 16, height: 20))
            label.text = "URL will be displayed as a QR Code"
            label.textColor = .lightGray
            label.font = UIFont.systemFont(ofSize: 12)
            footer.addSubview(label)
            return footer
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if !datePickerIsVisible && indexPath.section == 2 && indexPath.row == 1 {
            return 0
        } else if indexPath.section == 1 && indexPath.row == 0{
            return 150
        } else if datePickerIsVisible && indexPath.section == 2 && indexPath.row == 1{
            return 150
        } else {
            return 44
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0 {
            toggleShowDateDatepicker()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
