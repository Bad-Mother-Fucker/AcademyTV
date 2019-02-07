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
    @objc func dateDidChange(sender: UIDatePicker) {
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
    func getCurrent(date: Date) -> String{
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
    @objc func getContentViewer() {
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
