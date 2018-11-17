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
    
    // MARK: - CloudKit Variable
    var record: CKRecord!
    let database = CKContainer(identifier: "iCloud.com.KnightClub.Viewer").publicCloudDatabase
    
    var datePickerIsVisible = false
    let editButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(sendMessage))
    
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
        
        let color = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        
        self.title = "New Message"
        self.navigationItem.rightBarButtonItem = editButton
        self.tableView.backgroundColor = color
        self.tableView.backgroundView?.backgroundColor = color
        self.view.backgroundColor = color
//        self.tableView
//        let separator = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1))
//        separator.backgroundColor = .lightGray
//        self.tableView.tableFooterView = separator
    }
    
    @objc func dateDidChange(sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        self.dateLabel.text = dateFormatter.string(from: sender.date)
    }
    
    // MARK: - Private implementation
    @objc func sendMessage() {
        
        record = CKRecord(recordType: "GlobalMessages")
        
        record["title"] = textFields[0].text! as CKRecordValue
        record["subtitle"] = textFields[1].text! as CKRecordValue
        record["location"] = textFields[3].text! as CKRecordValue
        record["url"] = textFields[2].text! as CKRecordValue
        record["date"] = descriptionTextView.text! as CKRecordValue
        record["description"] = descriptionTextView.text! as CKRecordValue
        
        database.save(record) { (record, error) in
            let alert: UIAlertController
            guard let _ = record, error == nil else {
                alert = UIAlertController(title: "Error", message: "Error on save", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                return
            }
            alert = UIAlertController(title: "Success",
                                      message: "Message saved correctly",
                                      preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .cancel, handler: nil))
        }
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
