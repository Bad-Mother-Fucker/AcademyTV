//
//  AddPropsViewController.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 20/01/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//

import UIKit

/**
 ## UIViewController that allow you to add a new props.
 
 - Version: 1.0
 
 - Author: @GianlucaOrpello
 */
class AddPropsViewController: UIViewController {

    /**
     ## The selected props type.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var props: (title: String, description: String)!
    
    /**
     ## Is location Picker visible.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var locationPickerIsVisible: Bool = false
    
    /**
     ## Is date Picker visible.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var datePickerIsVisible: Bool = false
    
    /**
     ## Table View
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    /**
     ## The current number of character left for ticker message.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var numberOfChar = 70{
        didSet{
            if self.view != nil{
                if let label = self.view.viewWithTag(150) as? UILabel{
                    label.text = "\(numberOfChar) characters left"
                }
            }
        }
    }
    
    /**
     ## UIViewController - init Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    /**
     ## UIViewController - required init Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     ## UIViewController - viewDidLoad Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = props.title
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dissmissController))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(checkSummary))
        
        tableView = UITableView(frame: self.view.frame)
        tableView.tableFooterView = UIView()

        self.view.addSubview(tableView)
        
    }
    
    /**
     ## Dissmiss the Summary View controller and remove the navigation controller.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @objc func dissmissController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     ## Check all the information and air the prop.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @objc func checkSummary(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "someViewController")
        #warning("Compleate methods.")
        if props.title == Categories.GlobalMessage.rawValue {
            let checkOutVC = SummaryViewController()
            checkOutVC.categories = .GlobalMessage
            checkOutVC.isCheckoutMode = true
            checkOutVC.prop = getProp()
            self.navigationController?.pushViewController(checkOutVC, animated: true)
        }
        
    }
    
    func getProp() -> Any {
        switch props.title {
        case Categories.GlobalMessage.rawValue:
            let title = (tableView.cellForRow(at: IndexPath(row: 0, section: 2))?.viewWithTag(500) as! UITextField).text!
            let subtitle = (tableView.cellForRow(at: IndexPath(row: 1, section: 2))?.viewWithTag(500) as! UITextField).text!
            let description = (tableView.cellForRow(at: IndexPath(row: 2, section: 2))?.viewWithTag(500) as! UITextField).text
            let url = (tableView.cellForRow(at: IndexPath(row: 0, section: 3))?.viewWithTag(500) as! UITextField).text
            let location = (tableView.cellForRow(at: IndexPath(row: 1, section: 3))?.viewWithTag(500) as! UILabel).text
            let dateTime = (tableView.cellForRow(at: IndexPath(row: 2, section: 3))?.viewWithTag(500) as! UILabel).text
            
            if location == "None" {
                location = nil
            }
            
            let prop = GlobalMessage(title: title, subtitle: subtitle, location: location,date:(dateTime,nil) description: description, URL: url, timeToLive: 0)
            
        case Categories.TikerMessage.rawValue:
            
            let text = (tableView.cellForRow(at: IndexPath(row: 0, section: 2))?.viewWithTag(500) as! UITextField).text!
            
        case Categories.KeynoteViewer.rawValue:
            break
        case Categories.Timer.rawValue:
            break
        }
    }
    
    /**
     ## Action trigger when the switch value change.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @objc fileprivate func openOrCloseDatePicker(){
        toggleShowDateDatepicker()
    }
    
    /**
     ## Open or close the row with the date picker
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    fileprivate func toggleShowDateDatepicker () {
        datePickerIsVisible = !datePickerIsVisible
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    /**
     ## Open or close the row with the location picker
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    fileprivate func toggleShowLocationDatepicker() {
        datePickerIsVisible = !datePickerIsVisible
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
}

/**
 ## Extension needed for the table view implementation.
 
 - Version: 1.0
 
 - Author: @GianlucaOrpello
 */
extension AddPropsViewController: UITableViewDelegate, UITableViewDataSource{

    // MARK: - UITableView Delegate
    
    /**
     ## UITableView Delegate - heightForRowAt Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch props.title {
        case Categories.GlobalMessage.rawValue:
            switch indexPath.section{
            case 0:
                return 235
            case 1:
                return 75
            case 2:
                if indexPath.row == 2{
                    return 125
                }else{
                    return 44
                }
            case 3:
                if locationPickerIsVisible && indexPath.row == 2{
                    return 217
                }else if !locationPickerIsVisible && indexPath.row == 2{
                    return 0
                }else if datePickerIsVisible && indexPath.row == 4{
                    return 217
                }else if !datePickerIsVisible && indexPath.row == 4{
                    return 0
                }else{
                    return 50
                }
            default:
                return 0
            }
        case Categories.TikerMessage.rawValue:
            switch indexPath.section{
            case 0:
                return 235
            case 1, 2:
                return 60
            default:
                return 0
            }
        case Categories.KeynoteViewer.rawValue:
            switch indexPath.section{
            case 0:
                return 235
            case 1:
                return 115
            case 2:
                return 44
            default:
                return 0
            }
        default:
            return 0
        }
    }
    
    /**
     ## UITableView Delegate - titleForHeaderInSection Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch props.title {
        case Categories.GlobalMessage.rawValue:
            switch section{
            case 1:
                return "Description"
            case 2:
                return "Text"
            case 3:
                return "Detail"
            default:
                return nil
            }
        case Categories.TikerMessage.rawValue:
            switch section{
            case 1:
                return "Description"
            case 2:
                return "Text"
            default:
                return nil
            }
        case Categories.KeynoteViewer.rawValue:
            switch section{
            case 1:
                return "Description"
            case 2:
                return "File"
            default:
                return nil
            }
        default:
            return nil
        }
    }
    
    /**
     ## UITableView Delegate - didSelectRowAt Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard props.title == Categories.GlobalMessage.rawValue,
            indexPath.section == 3,
            indexPath.row == 1 else { return }
        
        toggleShowLocationDatepicker()
    }

    // MARK: - UITableView Data Source

    /**
     ## UITableView Data Source - numberOfSections Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        switch props.title {
        case Categories.GlobalMessage.rawValue:
            return 4
        case Categories.TikerMessage.rawValue:
            return 3
        case Categories.KeynoteViewer.rawValue:
            return 3
        default:
            return 0
        }
    }

    /**
     ## UITableView Data Source - numberOfRowsInSection Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1{
            return 1
        }else{
            switch props.title {
            case Categories.GlobalMessage.rawValue:
                if section == 2{
                    return 3
                }else if section == 3{
                    return 5
                }else{
                    return 0
                }
            case Categories.TikerMessage.rawValue:
                return 2
            case Categories.KeynoteViewer.rawValue:
                return 2
            default:
                return 0
            }
        }
    }

    /**
     ## UITableView Data Source - cellForRowAt Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            
            let imageView = UIImageView(frame: CGRect(x: 16, y: 14, width: self.view.frame.size.width - 32, height: 206))
            imageView.contentMode = .scaleAspectFit

            let image: UIImage?
            switch props.title {
            case Categories.GlobalMessage.rawValue:
                image = UIImage(named: "PreviewGlobalMessage")
                break
            case Categories.TikerMessage.rawValue:
                image = UIImage(named: "PreviewTicker")
                break
            case Categories.KeynoteViewer.rawValue:
                image = UIImage(named: "PreviewContentViewer")
                break
            default:
                image = nil
                break
            }
            
            imageView.image = image
            cell.contentView.addSubview(imageView)
            return cell
        }else{
            
            switch props.title {
            case Categories.GlobalMessage.rawValue:
                
                switch indexPath.section{
                    
                case 1:
                    let cell = UITableViewCell()
                    cell.selectionStyle = .none
                    
                    let label = UILabel(frame: CGRect(x: 16, y: 10, width: self.view.frame.size.width - 32, height: 54))
                    label.numberOfLines = 0
                    label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
                    label.textColor = .lightGray
                    label.text = "Displays a message with a title and description attached with location, date, time and a link displayed as a QR code."
                    
                    cell.contentView.addSubview(label)
                    return cell
                case 2:
                    switch indexPath.row{
                    case 0:
                        let cell = UITableViewCell()
                        cell.selectionStyle = .none
                        
                        let textField = UITextField(frame: CGRect(x: 16, y: 10, width: self.view.frame.size.width - 32, height: 36))
                        textField.delegate = self
                        textField.borderStyle = .none
                        textField.placeholder = "Title"
                        textField.tag = 500
                        
                        cell.contentView.addSubview(textField)
                        return cell
                    case 1:
                        let cell = UITableViewCell()
                        cell.selectionStyle = .none
                        
                        
                        let textField = UITextField(frame: CGRect(x: 16, y: 10, width: self.view.frame.size.width - 32, height: 36))
                        textField.delegate = self
                        textField.borderStyle = .none
                        textField.placeholder = "Description"
                        textField.tag = 500
                        cell.contentView.addSubview(textField)
                        return cell
                    case 2:
                        let cell = UITableViewCell()
                        cell.selectionStyle = .none
                        
                        let textField = UITextField(frame: CGRect(x: 16, y: 10, width: self.view.frame.size.width - 32, height: 105))
                        textField.delegate = self
                        textField.borderStyle = .none
                        textField.placeholder = "Message"
                        textField.tag = 500
                        
                        cell.contentView.addSubview(textField)
                        return cell
                    default:
                        return UITableViewCell()
                    }
                case 3:
                    
                    switch indexPath.row{
                    case 0:
                        
                        let cell = UITableViewCell()
                        cell.selectionStyle = .none
                        
                        let label = UILabel(frame: CGRect(x: 16, y: 10, width: 100, height: 22))
                        label.text = "URL"
                        
                        let textField = UITextField(frame: CGRect(x: self.view.frame.size.width - 167, y: 10, width: 157, height: 22))
                        textField.delegate = self
                        textField.borderStyle = .none
                        textField.textColor = .lightGray
                        textField.placeholder = "https://example.com"
                        textField.tag = 500
                        cell.contentView.addSubview(textField)
                        cell.contentView.addSubview(label)
                        return cell
                        
                    case 1:
                        
                        let cell = UITableViewCell()
                        cell.selectionStyle = .none
                        
                        let label = UILabel(frame: CGRect(x: 16, y: 10, width: 100, height: 22))
                        label.text = "Location"
                        
                        let locationLabel = UILabel(frame: CGRect(x: self.view.frame.size.width - 157, y: 10, width: 157, height: 22))
                        locationLabel.text = "None"
                        locationLabel.textColor = .lightGray
                        locationLabel.tag = 500
                        
                        cell.contentView.addSubview(locationLabel)
                        cell.contentView.addSubview(label)
                        return cell
                        
                    case 2:
                        let cell = UITableViewCell()
                        cell.selectionStyle = .none
                        
                        
                        
                        return cell
                    case 3:
                        
                        let cell = UITableViewCell()
                        cell.selectionStyle = .none
                        
                        let locationLabel = UILabel(frame: CGRect(x: 16, y: 10, width: 100, height: 22))
                        locationLabel.text = "Date & Time"
                        
                        let label = UILabel(frame: CGRect(x: self.view.frame.size.width - 180, y: 10, width: 110, height: 22))
                        label.numberOfLines = 0
                        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
                        label.textColor = .lightGray
                        label.text = "Today, 10:41"
                        label.tag = 500
                        let swi = UISwitch(frame: CGRect(x: self.view.frame.size.width - 65, y: 10, width: 55, height: 36))
                        swi.isOn = false
                        swi.addTarget(self, action: #selector(openOrCloseDatePicker), for: .valueChanged)
                        
                        
                        cell.contentView.addSubview(swi)
                        cell.contentView.addSubview(label)
                        cell.contentView.addSubview(locationLabel)
                        return cell
                        
                    case 4:
                        
                        let cell = UITableViewCell()
                        cell.selectionStyle = .none
                        
                        
                        
                        return cell
                        
                    default:
                        return UITableViewCell()
                    }
                default:
                    return UITableViewCell()
                }
                
            case Categories.TikerMessage.rawValue:
                switch indexPath.section{
                    
                case 1:
                    let cell = UITableViewCell()
                    cell.selectionStyle = .none
                    
                    let label = UILabel(frame: CGRect(x: 16, y: 10, width: self.view.frame.size.width - 32, height: 36))
                    label.numberOfLines = 0
                    label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
                    label.textColor = .lightGray
                    label.text = "Displays a short message always visible at the bottom of the screen."
                    
                    cell.contentView.addSubview(label)
                    return cell
                case 2:
                    if indexPath.row == 0{
                        let cell = UITableViewCell()
                        cell.selectionStyle = .none
                        
                        let textField = UITextField(frame: CGRect(x: 16, y: 10, width: self.view.frame.size.width - 32, height: 36))
                        textField.delegate = self
                        textField.tag = 100
                        textField.borderStyle = .none
                        textField.placeholder = "Message"
                        textField.tag = 500
                        cell.contentView.addSubview(textField)
                        return cell
                    }else{
                        let cell = UITableViewCell()
                        cell.selectionStyle = .none
                        
                        let label = UILabel(frame: CGRect(x: 16, y: 10, width: self.view.frame.size.width - 32, height: 36))
                        label.tag = 150
                        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
                        label.textColor = .lightGray
                        label.text = "\(numberOfChar) characters left"
                        
                        cell.contentView.addSubview(label)
                        return cell
                    }
                default:
                    return UITableViewCell()
                }
            case Categories.KeynoteViewer.rawValue:
                switch indexPath.section{
                    
                case 1:
                    let cell = UITableViewCell()
                    cell.selectionStyle = .none
                    
                    let label = UILabel(frame: CGRect(x: 16, y: 10, width: self.view.frame.size.width - 32, height: 90))
                    label.numberOfLines = 0
                    label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
                    label.textColor = .lightGray
                    label.text = "Displays an image or a file that covers most of the screen. Use a content with a transparent background to get the Viewer overlay. Prefer 16:9 PNG files. You can also use the share extension inside other apps like Keynote, Photos or Files."
                    
                    cell.contentView.addSubview(label)
                    return cell
                case 2:
                    
                    if indexPath.row == 0{
                    
                        let cell = UITableViewCell()
                        cell.selectionStyle = .none
                        
                        let button = UIButton(frame: CGRect(x: 16, y: 10, width: self.view.frame.size.width - 26, height: 22))
                        button.setTitle("Select from Photos", for: .normal)
                        button.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 1), for: .normal)
                        button.contentHorizontalAlignment = .left
                        #warning("Add Target to this button")
                        #warning("Remember to save the foto in keynoteFoto var to show in checkout VC")
                        cell.contentView.addSubview(button)
                        return cell
                        
                    }else{
                        
                        let cell = UITableViewCell()
                        cell.selectionStyle = .none
                        
                        let button = UIButton(frame: CGRect(x: 16, y: 10, width: self.view.frame.size.width - 26, height: 22))
                        button.setTitle("Select from Files", for: .normal)
                        button.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 1), for: .normal)
                        button.contentHorizontalAlignment = .left
                        #warning("Add Target to this button")
                        
                        cell.contentView.addSubview(button)
                        return cell
                    }
                    
                default:
                    return UITableViewCell()
                }
            default:
                return UITableViewCell()
            }
            
        }
    }
}

/**
 ## Extension for UITextFieldDelegate implementation.
 
 - Version: 1.0
 
 - Author: @GianlucaOrpello
 */
extension AddPropsViewController: UITextFieldDelegate{
    
    /**
     ## UITextFieldDelegate - textFieldShouldReturn Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    /**
     ## UITextFieldDelegate - shouldChangeCharactersIn Methods

     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, textField.tag == 100 else { return false }
        let newLength = text.count + string.count - range.length
        numberOfChar = 70 - newLength
        
        if numberOfChar > 0{
            return true
        }else{
            return false
        }
    }
}

typealias TickerMessage = String
typealias Keynote = [UIImage]

