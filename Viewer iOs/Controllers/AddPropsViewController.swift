//
//  AddPropsViewController.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 20/01/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//
import UIKit
import MobileCoreServices

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
    var datePickerIsVisible: Bool = false{
        didSet{
            guard self.title == Categories.globalMessage.rawValue else { return }
            if datePickerIsVisible == false{
                if let label = tableView.cellForRow(at: IndexPath(row: 2, section: 3))?.viewWithTag(500) as? UILabel {
                    label.text = "None"
                }
            }
        }
    }
    
    /**
     ## Selected location , Selected DateTime, Selected Keynote
     
     Used only for GlobalMessage Promp
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var selectedLocation: Locations = .none {
        didSet {
            if let label = tableView.cellForRow(at: IndexPath(row: 1, section: 3))?.viewWithTag(500) as? UILabel {
                label.text = selectedLocation.rawValue
            }
        }
    }
    
    
    
    var selectedDateTime: String = "" {
        didSet {
            (tableView.cellForRow(at: IndexPath(row: 3, section: 3))?.viewWithTag(500) as? UILabel)?.text = selectedDateTime
        }
        
    }
    
    var keynote: [UIImage]? = []
    
    /**
     ## Table View
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self

            tableView.register(FullImageTableViewCell.self, forCellReuseIdentifier: "FullImageTableViewCell")
            tableView.register(CenteredButtonTableViewCell.self, forCellReuseIdentifier: "CenteredButtonTableViewCell")
            tableView.register(FullLightTextTableViewCell.self, forCellReuseIdentifier: "FullLightTextTableViewCell")
            tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "TextFieldTableViewCell")
            tableView.register(LabelAndTextfieldTableViewCell.self, forCellReuseIdentifier: "LabelAndTextfieldTableViewCell")
            tableView.register(MasterAndDetailLabelsTableViewCell.self, forCellReuseIdentifier: "MasterAndDetailLabelsTableViewCell")
            tableView.register(MasterDetailLabelsAndSwitchTableViewCell.self, forCellReuseIdentifier: "MasterDetailLabelsAndSwitchTableViewCell")
        }
    }
    
    /**
     ## The current number of character left for ticker message.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var numberOfChar = 70 {
        didSet {
            if self.view != nil {
                if let label = self.view.viewWithTag(150) as? UILabel {
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
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        tableView = UITableView(frame: self.view.frame)
        tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "GetAllSelectedPhotos"), object: nil, queue: .main) { (notification) in
            if let images = notification.userInfo?["images"] as? [UIImage] {
                self.keynote = images
            }
        }

        self.view.addSubview(tableView)
        
    }
    
    /**
     ## Dissmiss the Summary View controller and remove the navigation controller.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @objc func dissmissController() {
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     ## Check all the information and air the prop.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @objc func checkSummary() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SetsViewController") as? TvListViewController
//        #warning("Compleate methods.")
        if props.title == Categories.globalMessage.rawValue {
            let checkOutVC = SummaryViewController()
            checkOutVC.categories = .globalMessage
            checkOutVC.isCheckoutMode = true
            checkOutVC.prop = getProp()
            self.navigationController?.pushViewController(checkOutVC, animated: true)
        } else if props.title == Categories.tickerMessage.rawValue {
            
            controller?.category = .tickerMessage
            controller?.tickerMessage = (getProp() as? String)
            navigationController?.pushViewController(controller ?? SummaryViewController(), animated: true)
        } else if props.title == Categories.keynoteViewer.rawValue {
            controller?.category = .keynoteViewer
            controller?.keynote = getProp() as? [UIImage]? ?? [UIImage]()
            navigationController?.pushViewController(controller ?? SummaryViewController(), animated: true)
        }
        
        
    }
    
    // Todo: Check this function...
    func getProp() -> Any? {
        switch props.title {
        case Categories.globalMessage.rawValue:
            let title = (tableView.cellForRow(at: IndexPath(row: 0, section: 2))?.viewWithTag(500) as? UITextField)?.text!
            let subtitle = (tableView.cellForRow(at: IndexPath(row: 1, section: 2))?.viewWithTag(500) as? UITextField)?.text!
            let description = (tableView.cellForRow(at: IndexPath(row: 2, section: 2))?.viewWithTag(500) as? UITextField)?.text
            let url = (tableView.cellForRow(at: IndexPath(row: 0, section: 3))?.viewWithTag(500) as? UITextField)?.text
            var location = (tableView.cellForRow(at: IndexPath(row: 1, section: 3))?.viewWithTag(500) as? UILabel)?.text
            let dateTime = (tableView.cellForRow(at: IndexPath(row: 3, section: 3))?.viewWithTag(500) as? UILabel)?.text

            if location == "None" {
                location = nil
            }

            let prop = GlobalMessage(title: title ?? " ",
                                     subtitle: subtitle ?? " ",
                                     location: location,
                                     date: (dateTime, nil),
                                     description: description,
                                     URL: URL(string: url ?? ""),
                                     timeToLive: 0)
      
            return prop
        case Categories.tickerMessage.rawValue:
            let text = (tableView.cellForRow(at: IndexPath(row: 0, section: 2))?.viewWithTag(500) as? UITextField)?.text!
            return text
        case Categories.keynoteViewer.rawValue:
            return keynote
        case Categories.timer.rawValue:
            return "nil"
        default:
            return ""
        }
    }
    
    /**
     ## Action trigger when the switch value change.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @objc func openOrCloseDatePicker() {
        toggleShowDateDatepicker()
        tableView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        tableView.deselectRow(at: IndexPath(row: 4, section: 3), animated: true)
    }
    
    /**
     ## Open or close the row with the date picker
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func toggleShowDateDatepicker () {
        datePickerIsVisible = !datePickerIsVisible

        if locationPickerIsVisible == false{
            if let label = tableView.cellForRow(at: IndexPath(row: 2, section: 3))?.viewWithTag(500) as? UILabel {
                label.text = "None"
            }
        }
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [IndexPath(row: 4, section: 3)], with: .automatic)
        self.tableView.endUpdates()
    }
    
    /**
     ## Open or close the row with the location picker
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func toggleShowLocationDatepicker() {
        locationPickerIsVisible = !locationPickerIsVisible
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [IndexPath(row: 2, section: 3)], with: .automatic)
        self.tableView.endUpdates()
    }

    /**
     ## Date Did Change

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    @objc fileprivate func dateDidChange(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        selectedDateTime = dateFormatter.string(from: sender.date)
    }

    /**
     ## Get Current Date

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    fileprivate func getCurrent(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    /**
     ## Present the Action sheet.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @objc fileprivate func getContentViewer() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.getCamera()
        })

        sheet.addAction(UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.getPhotos()
        })

        sheet.addAction(UIAlertAction(title: "Browse Files", style: .default) { _ in
            self.getDocumentPicker()
        })

        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(sheet, animated: true, completion: nil)
    }
    
    /**
     ## Present the camera Controller.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    private func getCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    /**
     ## Present the Image gallery.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    private func getPhotos() {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "ImagePickerViewController")
        self.present(vc, animated: true)
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    /**
     ## Present the Document View Controller
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    private func getDocumentPicker() {
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypeImage)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
}

/**
 ## Extension needed for the table view implementation.

 - Version: 1.0

 - Author: @GianlucaOrpello
 */
extension AddPropsViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - UITableView Delegate

    /**
     ## UITableView Delegate - heightForRowAt Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch props.title {
        case Categories.globalMessage.rawValue:
            switch indexPath.section {
            case 0:
                return 235
            case 1:
                return 75
            case 2:
                if indexPath.row == 2 {
                    return 125
                } else {
                    return 44
                }
            case 3:
                if locationPickerIsVisible && indexPath.row == 2 {
                    return 217
                } else if !locationPickerIsVisible && indexPath.row == 2 {
                    return 0
                } else if datePickerIsVisible && indexPath.row == 4 {
                    return 217
                } else if !datePickerIsVisible && indexPath.row == 4 {
                    return 0
                } else {
                    return 50
                }
            default:
                return 0
            }
        case Categories.tickerMessage.rawValue:
            switch indexPath.section {
            case 0:
                return 235
            case 1, 2:
                return 60
            default:
                return 0
            }
        case Categories.keynoteViewer.rawValue:
            switch indexPath.section {
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
        guard section != 1 else { return "Description" }

        switch props.title {
        case Categories.globalMessage.rawValue:
            switch section {
            case 2:
                return "Text"
            case 3:
                return "Detail"
            default:
                return nil
            }
        case Categories.tickerMessage.rawValue:
            switch section {
            case 2:
                return "Text"
            default:
                return nil
            }
        case Categories.keynoteViewer.rawValue:
            switch section {
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
        guard props.title == Categories.globalMessage.rawValue,
            indexPath.section == 3,
            indexPath.row == 1 else { return }

        toggleShowLocationDatepicker()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - UITableView Data Source

    /**
     ## UITableView Data Source - numberOfSections Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        switch props.title {
        case Categories.globalMessage.rawValue:
            return 4
        case Categories.tickerMessage.rawValue:
            return 3
        case Categories.keynoteViewer.rawValue:
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
        guard section != 0, section != 1 else { return 1 }

        switch props.title {
        case Categories.globalMessage.rawValue:
            if section == 2 {
                return 3
            } else if section == 3 {
                return 5
            } else {
                return 0
            }
        case Categories.tickerMessage.rawValue:
            return 2
        case Categories.keynoteViewer.rawValue:
            return 1
        default:
            return 0
        }
    }

    /**
     ## UITableView Data Source - cellForRowAt Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {

            if let cell = tableView.dequeueReusableCell(withIdentifier: "FullImageTableViewCell") as? FullImageTableViewCell {
                cell.fullImage = UIImage(named: props.title)
                return cell
            } else { return UITableViewCell() }

        } else {

            switch props.title {
            // MARK: Global Message
            case Categories.globalMessage.rawValue:

                switch indexPath.section {
                case 1:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "FullLightTextTableViewCell") as? FullLightTextTableViewCell{
                        cell.fullText = "Displays a message with a title and description attached with location, date, time and a link displayed as a QR code."
                        cell.fullTextColor = .lightGray
                        cell.fullTextFont = UIFont.systemFont(ofSize: 13)
                        return cell
                    } else { return UITableViewCell() }

                case 2:
                    switch indexPath.row {
                    case 0:

                        if let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell") as? TextFieldTableViewCell{

                            cell.placeholderText = "Title"
                            cell.delegate = self

                            return cell
                        } else { return UITableViewCell() }

                    case 1:

                        if let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell") as? TextFieldTableViewCell{

                            cell.placeholderText = "Description"
                            cell.delegate = self

                            return cell
                        } else { return UITableViewCell() }

                    case 2:

                        if let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell") as? TextFieldTableViewCell{

                            cell.placeholderText = "Message"
                            cell.delegate = self

                            return cell
                        } else { return UITableViewCell() }


                    default:
                        return UITableViewCell()
                    }
                case 3:

                    switch indexPath.row {
                    case 0:

                        if let cell = tableView.dequeueReusableCell(withIdentifier: "LabelAndTextfieldTableViewCell") as? LabelAndTextfieldTableViewCell{

                            cell.titleText = "URL"
                            cell.delegate = self
                            cell.placeholderText = "https://example.com"

                            return cell
                        } else { return UITableViewCell() }

                    case 1:

                        if let cell = tableView.dequeueReusableCell(withIdentifier: "MasterAndDetailLabelsTableViewCell") as? MasterAndDetailLabelsTableViewCell{

                            cell.mainText = "Location"
                            cell.detailText = selectedLocation.rawValue

                            return cell
                        } else { return UITableViewCell() }
                    case 2:
                        let cell = UITableViewCell()
                        cell.selectionStyle = .none

                        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 217))
                        picker.delegate = self
                        picker.dataSource = self
                        picker.isHidden = !locationPickerIsVisible

                        cell.contentView.addSubview(picker)
                        return cell
                    case 3:

                        if let cell = tableView.dequeueReusableCell(withIdentifier: "MasterDetailLabelsAndSwitchTableViewCell") as? MasterDetailLabelsAndSwitchTableViewCell {

                            cell.mainText = "Date & Time"
                            cell.isSwitchOn = datePickerIsVisible
                            cell.addTarget(self, action: #selector(openOrCloseDatePicker))
                            cell.detailText = cell.isSwitchOn! ? getCurrent(date: Date()) : "None"
                            return cell
                        } else { return UITableViewCell() }
                    case 4:

                        let cell = UITableViewCell()
                        cell.selectionStyle = .none

                        let picker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 217))
                        picker.datePickerMode = .dateAndTime
                        picker.isHidden = !datePickerIsVisible
                        picker.addTarget(self, action: #selector(dateDidChange(sender:)), for: .valueChanged)

                        cell.contentView.addSubview(picker)
                        return cell

                    default:
                        return UITableViewCell()
                    }
                default:
                    return UITableViewCell()
                }

            // MARK: Ticker Message
            case Categories.tickerMessage.rawValue:
                switch indexPath.section {

                case 1:

                    if let cell = tableView.dequeueReusableCell(withIdentifier: "FullLightTextTableViewCell") as? FullLightTextTableViewCell{
                        cell.fullText = "Displays a short message always visible at the bottom of the screen."
                        cell.fullTextColor = .lightGray
                        cell.fullTextFont = UIFont.systemFont(ofSize: 13)
                        return cell
                    } else { return UITableViewCell() }

                case 2:
                    if indexPath.row == 0 {
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell") as? TextFieldTableViewCell{

                            cell.delegate = self
                            cell.placeholderText = "Message"
                            return cell
                        } else { return UITableViewCell() }
                    } else {
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "FullLightTextTableViewCell") as?
                            FullLightTextTableViewCell {
                            cell.fullText = "\(numberOfChar) characters left"
                            cell.fullTextColor = .lightGray
                            cell.fullTextFont = UIFont.systemFont(ofSize: 13)
                            return cell
                        } else { return UITableViewCell() }
                    }
                default:
                    return UITableViewCell()
                }

            // MARK: Content Viewer
            case Categories.keynoteViewer.rawValue:
                switch indexPath.section {
                case 1:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "FullLightTextTableViewCell") as? FullLightTextTableViewCell{
                        cell.fullText = "Displays an image or a file that covers most of the screen. Use a content with a transparent background to get the Viewer overlay. Prefer 16:9 PNG files. You can also use the share extension inside other apps like Keynote, Photos or Files."
                        cell.fullTextColor = .lightGray
                        cell.fullTextFont = UIFont.systemFont(ofSize: 13)
                        return cell
                    } else { return UITableViewCell() }

                case 2:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "CenteredButtonTableViewCell") as? CenteredButtonTableViewCell{
                        cell.title = "Select Content"
                        cell.titleColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
                        cell.horizontalAlignment = .left
                        cell.addTarget(self, action: #selector(getContentViewer))
                        return cell
                    } else { return UITableViewCell() }
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
extension AddPropsViewController: UITextFieldDelegate {

    /**
     ## UITextFieldDelegate - textFieldShouldReturn Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        let textFields = [tableView.cellForRow(at: IndexPath(row: 0, section: 2))?.viewWithTag(500) as? UITextField,
                          tableView.cellForRow(at: IndexPath(row: 1, section: 2))?.viewWithTag(500) as? UITextField,
                          tableView.cellForRow(at: IndexPath(row: 2, section: 2))?.viewWithTag(500) as? UITextField]

        switch self.title {
        case Categories.globalMessage.rawValue:

            if let index = textFields.index(of: textField){
                if let nextTextField = textFields[index + 1] {
                    nextTextField.becomeFirstResponder()
                }
            }

        default:
            textField.endEditing(true)
        }

        tableView.setContentOffset(CGPoint.zero, animated: true)
        return true
    }

    /**
     ## UITextFieldDelegate - shouldChangeCharactersIn Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {


        guard let text = textField.text, textField.tag == 500 else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            return false

        }
        let newLength = text.count + string.count - range.length

        if newLength == 0 {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        numberOfChar = 70 - newLength
        return numberOfChar > 0 ? true : false
    }

    /**
     ## UITextFieldDelegate - textFieldDidBeginEditing Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.title == Categories.globalMessage.rawValue {
            tableView.setContentOffset(CGPoint(x: 0, y: textField.center.y + 100), animated: true)
        }
    }
}

// MARK: - Extension for UIPickerController
extension AddPropsViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - UIPickerView Delegate

    /**
     ## UIPickerViewDelegate - titleForRow Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Locations.allCases[row].rawValue
    }

    /**
     ## UIPickerViewDelegate - didSelectRow Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLocation = Locations.allCases[row]
    }

    // MARK: - UIPickerView Data Source

    /**
     ## UIPickerViewDataSource - numberOfComponents Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    /**
     ## UIPickerViewDataSource - numberOfRowsInComponent Methods

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Locations.allCases.count
    }
}

extension AddPropsViewController: UIDocumentPickerDelegate, UINavigationControllerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)

        let story = UIStoryboard(name: "Main", bundle: nil)
        if let destination = story.instantiateViewController(withIdentifier: "SetsViewController") as? TvListViewController {
            for url in urls {
                do {
                    let data = try Data(contentsOf: url)
                    destination.keynote?.append(UIImage(data: data)!)
                    destination.category = .keynoteViewer
                    self.navigationController?.pushViewController(destination, animated: true)
                } catch {
                    NSLog("Error on getting data - AddPropsViewController: didPickDocumentsAt")
                }
            }
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddPropsViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)

        let story = UIStoryboard(name: "Main", bundle: nil)
        if let destination = story.instantiateViewController(withIdentifier: "SetsViewController") as? TvListViewController {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                destination.keynote = [image.byFixingOrientation()]
                destination.category = .keynoteViewer
            }
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    // swiftlint:disable file_length
}
