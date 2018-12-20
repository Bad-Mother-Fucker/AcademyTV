//
//  TickerViewController.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 12/12/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

class TickerViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var selectedGroup: TVGroup = .lab1

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var selectAreaButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        selectAreaButton.setTitle(globalGroups.first?.name.rawValue, for: .normal)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return globalGroups.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return globalGroups[row].name.rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGroup = globalGroups[row].name
        selectAreaButton.setTitle(selectedGroup.rawValue, for: .normal)
    }
    
    @IBAction func selectArea(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Select area", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        alert.isModalInPopover = true
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        
        alert.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert,animated: true, completion: nil )
    }
    
    @IBAction func saveThickerMessage(_ sender: UIBarButtonItem) {
        if let message = textField.text{
            if message != ""{
                CKController.postServiceMessage(message, onTvGroup: selectedGroup)
            }else{
                let alert = UIAlertController(title: "Add a message to post", message: "The message to post cann't be empty", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

