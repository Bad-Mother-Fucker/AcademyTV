//
//  SummaryTableViewController.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 16/01/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//

import UIKit
import MessageUI
import CloudKit
/**
 ## Summary View Controller with the goal of manage all the information of each props.
 
 - Todo: Add theConstraits.
 
 - Version: 1.0
 
 - Author: @GianlucaOrpello
 */
class SummaryViewController: UIViewController, MFMailComposeViewControllerDelegate{
    
    var tableView: UITableView!
    
    /**
     ## isCheckoutMode
     
     - Note: Indicates if the controller is used for checkout or not
     
     - Version: 1.0
     
     - Author: @Micheledes
     */
    
    var isCheckoutMode: Bool = false
    
    /**
     ## The selected prop.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var prop: Any?
    
    /**
     ## The keynote passed.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var keynote: (image: [UIImage]?, tvName: String?, TVGroup: [TVGroup]?)?
    
    /**
     ## The categories of the object passed to this view.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var categories: Categories?
    
    /**
     ## Collection View used for display the keynotes images.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var collectionView: UICollectionView?
    
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
     
     * Set the title of the Controller
     * Add the UIBarButtonItems
     * Add the Table View
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Summary"
        
        if isCheckoutMode {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(pop))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(postProp))
        }else if categories?.rawValue == Categories.GlobalMessage.rawValue {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "edit", style:.done, target: self, action: #selector(editProp))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "back", style:.plain, target: self, action: #selector(dissmissController))
        } else {
             self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "back", style:.plain, target: self, action: #selector(dissmissController))
        }
        
        
        
        getCurrentCategories()
        
        tableView = UITableView(frame: self.view.frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
    }
    
    /**
     ## Get the current category of page based of the selectd prop.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    private func getCurrentCategories(){
        if let _ = prop as? (message: String, tvName: String?, TVGroup: [TVGroup]?){
            self.categories = .TickerMessage
        }else if let key = prop as? (image: [UIImage]?, tvName: String?, TVGroup:  [TVGroup]?){
            self.categories = .KeynoteViewer
            keynote = key
            print(keynote)
        }else if let _ = prop as? GlobalMessage{
            self.categories = .GlobalMessage
        }
    }
    
    
    @objc func postProp() {
        debugPrint("PostProp")
        if let cat = categories{
            switch cat {
            case Categories.TickerMessage:
                let ticker = prop as! (message: String, tvName: String, TVGroup: [TVGroup])
                ticker.TVGroup.forEach { (group) in
                    CKController.postTickerMessage(ticker.message, onTvGroup: group)
                }
                self.navigationController?.dismiss(animated: true, completion: nil)
            case Categories.KeynoteViewer:
                let keynote = prop as! (image: [UIImage]?, tvName: String, TVGroup:  [TVGroup])
                keynote.TVGroup.forEach { (group) in
                    CKController.postKeynote(keynote.image!, ofType: .PNG, onTVsOfGroup: group)
                }
                self.navigationController?.dismiss(animated: true, completion: nil)
            case Categories.GlobalMessage:
                let gm = prop as! GlobalMessage
                CKController.postMessage(title: gm.title, subtitle: gm.subtitle, location: gm.location, date: gm.date, description: gm.description, URL: gm.url, timeToLive: 0)
                
                self.navigationController?.dismiss(animated: true, completion: nil)
                
            default:
                break
            }
            
            let alert = UIAlertController(title: "Saved", message: "The prop will appaire in a few seconds", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @objc func editProp() {
        if let cat = categories{
            switch cat {
            case Categories.TickerMessage:
               
                break
            case Categories.KeynoteViewer:
             
                break
            case Categories.GlobalMessage:
                let gm = prop as! GlobalMessage
                gm.title = (tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.viewWithTag(500) as? UILabel)?.text ?? ""
                gm.subtitle = (tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.viewWithTag(501) as? UILabel)?.text ?? ""
                gm.location = (tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.viewWithTag(505) as? UILabel)?.text ?? ""
                gm.date.0 = (tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.viewWithTag(504) as? UITextField)?.text ?? ""
                gm.description = (tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.viewWithTag(502) as? UITextField)?.text ?? ""
                gm.url = URL(string: (tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.viewWithTag(503) as? UITextField)?.text ?? "")
                
                let operation = CKModifyRecordsOperation(recordsToSave: [gm.record], recordIDsToDelete: nil)
                CKKeys.database.add(operation)
                self.navigationController?.dismiss(animated: true, completion: nil)
                
            default:
                break
            }
            
            let alert = UIAlertController(title: "Saved", message: "The prop will appaire in a few seconds", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
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
    
    /**
     ## Remove ticker message form CloudKit
    
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @objc fileprivate func remove(){
        
        let alert = UIAlertController(title: "Delete Prop", message: "The prop will be removed from all the screens. This cannot be undone.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let delete = UIAlertAction(title: "Delete", style: .cancel, handler: { [weak self] (action) in
            
            if let ticker = self?.prop as? (message: String, tvName: String){
                CKController.removeTickerMessage(fromTVNamed: ticker.tvName)
            }else if let keynote = self?.prop as? (image: [UIImage]?, tvName: String){
                CKController.removeKeynote(FromTV: keynote.tvName)
            }else if let globalMessage = self?.prop as? GlobalMessage{
                CKController.remove(globalMessage: globalMessage)
            }
            
            self?.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(cancel)
        alert.addAction(delete)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     ## Dissmiss the Summary View controller and remove the navigation controller.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @objc func dissmissController(){
        self.dismiss(animated: true) {
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    /**
     ## Goes back to the previous view controller.
     
     - Version: 1.0
     
     - Author: @Micheledes
     */
    @objc func pop() {
        navigationController?.popViewController(animated: true)
    }
}



extension SummaryViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    // MARK: - UITableViewDelegate
    
    /**
     ## UITableViewDelegate - heightForRowAt Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch categories! {
        case .TickerMessage:
            // Total of 6 rows
            
            switch indexPath.row{
            case 0:
                return 54
            case 4, 5:
                return 44
            case 1, 2, 3:
                return 94
            default:
                return 0
            }
            
        case .GlobalMessage:
            // Total of 6 rows
            
            switch indexPath.row{
            case 0, 4, 5:
                return 44
            case 1:
                return 228
            case 2:
                return 210
            case 3:
                return 94
            default:
                return 0
            }
           
        case .KeynoteViewer:
            // Total of 5 rows

            switch indexPath.row{
            case 0, 3, 4:
                return 44
            case 1:
                return 191
            case 2:
                return 94
            default:
                return 0
            }

        case .Timer:
            return 0
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - UITableViewDataSource
    
    /**
     ## UITableViewDataSource - numberOfSections Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /**
     ## UITableViewDataSource - numberOfRowsInSection Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch categories! {
        case .TickerMessage, .GlobalMessage:
            return isCheckoutMode ? 4:6
        case .KeynoteViewer:
            return isCheckoutMode ? 3:5
        case .Timer:
            return 0
        }
    }
    
    /**
     ## UITableViewDataSource - cellForRowAt Methods
     
     - Todo: Customize the separator.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            tableView.separatorStyle = .none
            
            let image = UIImageView(frame: CGRect(x: 16, y: 12, width: 40, height: 40))
            let textLabel = UILabel(frame: CGRect(x: 72, y: 20, width: 287, height: 24))
            image.contentMode = .scaleAspectFit
            
            switch categories!{
            case .TickerMessage:
                image.image = UIImage(named: "Ticker")
                textLabel.text = Categories.TickerMessage.rawValue
                break
            case .KeynoteViewer:
                image.image = UIImage(named: "Keynote")
                textLabel.text = Categories.KeynoteViewer.rawValue
                break
            case .GlobalMessage:
                image.image = UIImage(named: "GlobalMessage")
                textLabel.text = Categories.GlobalMessage.rawValue
                break
            case .Timer:
                break
            }
            
            cell.contentView.addSubview(image)
            cell.contentView.addSubview(textLabel)
            
            return cell
            
        }else{
            
            switch categories!{
            case .TickerMessage:
                // Total of 6 rows

                let tickerMessage = prop as! (message: String, tvName: String?, TVGroup: [TVGroup]?)
                
                switch indexPath.row{
                case 1:
                    
                    let cell = UITableViewCell()
                    cell.selectionStyle = .none
                    tableView.separatorStyle = .singleLine
                    
                    let label = UILabel(frame: CGRect(x: 72, y: 12, width: 287, height: 22))
                    label.text = "Text"
                    
                    let textLabel = UILabel(frame: CGRect(x: 72, y: 38, width: 287, height: 44))
                    textLabel.text = tickerMessage.message
                    textLabel.textColor = UIColor(red: 0, green: 119/255, blue: 1, alpha: 1)
                    
                    cell.contentView.addSubview(label)
                    cell.contentView.addSubview(textLabel)
                    
                    return cell
                    
                case 2:
                    
                    let cell = UITableViewCell()
                    cell.selectionStyle = .none
                    tableView.separatorStyle = .singleLine
                    
                    let label = UILabel(frame: CGRect(x: 72, y: 10, width: 287, height: 22))
                    label.text = "Sets"
                    
                    let secondLabel = UILabel(frame: CGRect(x: 72, y: 37, width: 287, height: 44))
                    secondLabel.numberOfLines = 0
                    
                    var tvNamesString = String()
                    
                    if let groups = tickerMessage.TVGroup{
                        for tm in groups{
                            tvNamesString.append(contentsOf: tm.rawValue)
                            tvNamesString.append(contentsOf: ",")
                        }
                        tvNamesString.removeLast()
                    }
                    
                    
                    
                    secondLabel.text = tvNamesString
                    
                    secondLabel.textColor = UIColor(red: 0, green: 119/255, blue: 1, alpha: 1)
                    
                    cell.contentView.addSubview(label)
                    cell.contentView.addSubview(secondLabel)
                    
                    return cell
                    
                case 3:
                    
                    let cell = UITableViewCell()
                    cell.selectionStyle = .none
                    tableView.separatorStyle = .singleLine
                    
                    let label = UILabel(frame: CGRect(x: 72, y: 10, width: 287, height: 66))
                    label.numberOfLines = 0
                    label.text = "If a screen is already airing a Ticker Message, it will be erased and replaced by this one"
                    label.textColor = .black
                    label.font = UIFont.systemFont(ofSize: 17)
                    
                    cell.contentView.addSubview(label)
                    
                    return cell
                    
                case 4:
                    
                    let cell = UITableViewCell()
                    tableView.separatorStyle = .singleLine
                    cell.selectionStyle = .none

                    let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: cell.contentView.frame.height))
                    button.setTitle("Delete Prop", for: .normal)
                    button.setTitleColor(.red, for: .normal)
                    
                    button.addTarget(self, action: #selector(remove), for: .touchUpInside)
                    
                    cell.contentView.addSubview(button)
                    
                    return cell
                    
                case 5:
                    
                    let cell = UITableViewCell()
                    cell.selectionStyle = .none
                    tableView.separatorStyle = .none
                    
                    let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: cell.contentView.frame.height))
                    button.setTitle("Something's wrong?", for: .normal)
                    button.setTitleColor(UIColor(red: 0, green: 119/255, blue: 1, alpha: 1), for: .normal)
                    button.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
                    
                    cell.contentView.addSubview(button)
                    
                    return cell
                    
                default:
                    return UITableViewCell()
                }
                
            case .KeynoteViewer:
                // Total of 5 rows

                keynote = prop as? (image: [UIImage]?, tvName: String?, TVGroup: [TVGroup]?)
                
                switch indexPath.row{
                    
                case 1:
                    
                    let cell = UITableViewCell()
                    tableView.separatorStyle = .singleLine
                    cell.selectionStyle = .none
                    
                    let layout = UICollectionViewFlowLayout()
                    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    layout.itemSize = CGSize(width: 277, height: 151)
                    layout.minimumLineSpacing = 10
                    layout.minimumInteritemSpacing = 10
                    layout.scrollDirection = .horizontal
                    
                    if collectionView == nil{
                        collectionView = UICollectionView(frame: CGRect(x: 0, y: 10, width: self.view.frame.width, height: 161), collectionViewLayout: layout)
                        
                        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
                        
                        collectionView!.backgroundColor = .clear
                        collectionView!.dataSource = self
                        collectionView!.allowsSelection = false
                        collectionView!.showsVerticalScrollIndicator = false
                        collectionView!.showsHorizontalScrollIndicator = false
                        
                        cell.contentView.addSubview(collectionView!)
                    }
                    
                    return cell
                    
                case 2:
                    
                    let cell = UITableViewCell()
                    cell.selectionStyle = .none
                    tableView.separatorStyle = .singleLine
                    
                    let label = UILabel(frame: CGRect(x: 72, y: 15, width: 287, height: 66))
                    label.numberOfLines = 0
                    label.text = "Content will automatically loop if more than one file is selected"
                    label.textColor = .black
                    label.font = UIFont.systemFont(ofSize: 17)
                    
                    cell.contentView.addSubview(label)
                    
                    return cell
                    
                case 3:
                    
                    let cell = UITableViewCell()
                    cell.selectionStyle = .none
                    
                    let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: cell.contentView.frame.height))
                    button.setTitle("Delete Prop", for: .normal)
                    button.setTitleColor(.red, for: .normal)
                    
                    button.addTarget(self, action: #selector(remove), for: .touchUpInside)

                    cell.contentView.addSubview(button)
                    
                    return cell
                    
                case 4:
                    
                    let cell = UITableViewCell()
                    cell.selectionStyle = .none
                    tableView.separatorStyle = .none
                    
                    let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: cell.contentView.frame.height))
                    button.setTitle("Something's wrong?", for: .normal)
                    button.setTitleColor(UIColor(red: 0, green: 119/255, blue: 1, alpha: 1), for: .normal)
                    button.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
                    
                    cell.contentView.addSubview(button)
                    
                    return cell
                    
                default:
                    return UITableViewCell()
                }
            case .GlobalMessage:
                // Total of 6 rows

                let globalMessage = prop as! GlobalMessage
                
                switch indexPath.row{
                    
                case 1:
                    
                    let cell = UITableViewCell()
                    cell.selectionStyle = .none
                    tableView.separatorStyle = .singleLine
                    
                    let title = UILabel(frame: CGRect(x: 72, y: 10, width: 287, height: 22))
                    let subtitle = UILabel(frame: CGRect(x: 72, y: 77, width: 287, height: 22))
                    let text = UILabel(frame: CGRect(x: 72, y: 150, width: 287, height: 22))
                    
                    title.text = "Title"
                    subtitle.text = "Subtitle"
                    text.text = "Text"
                    
                    let titleLabel = UILabel(frame: CGRect(x: 72, y: 32, width: 287, height: 44))
                    let subtitleLabel = UILabel(frame: CGRect(x: 72, y: 105, width: 287, height: 44))
                    let textLabel = UILabel(frame: CGRect(x: 72, y: 175, width: 287, height: 44))
                    
                    titleLabel.text = globalMessage.title
                    subtitleLabel.text = globalMessage.subtitle
                    textLabel.text = globalMessage.description
                    
                    titleLabel.tag = 500
                    subtitleLabel.tag = 501
                    textLabel.tag = 502
                    textLabel.numberOfLines = 0
                    
                    let color = UIColor(red: 0, green: 119/255, blue: 1, alpha: 1)
                    
                    titleLabel.textColor = color
                    subtitleLabel.textColor = color
                    textLabel.textColor = color

                    cell.contentView.addSubview(title)
                    cell.contentView.addSubview(subtitle)
                    cell.contentView.addSubview(text)
                    
                    cell.contentView.addSubview(titleLabel)
                    cell.contentView.addSubview(subtitleLabel)
                    cell.contentView.addSubview(textLabel)
                    
                    return cell
                    
                case 2:
                    
                    let cell = UITableViewCell()
                    cell.selectionStyle = .none
                    tableView.separatorStyle = .singleLine
                    
                    let url = UILabel(frame: CGRect(x: 72, y: 15, width: 287, height: 22))
                    let dateTime = UILabel(frame: CGRect(x: 72, y: 80, width: 287, height: 22))
                    let location = UILabel(frame: CGRect(x: 72, y: 145, width: 287, height: 22))
                    
                    url.text = "URL"
                    dateTime.text = "Date & Time"
                    location.text = "Location"
                    
                    let urlTextEdit = UITextField(frame: CGRect(x: 72, y: 35, width: 287, height: 44))
                    let dateTimeTextEdit = UITextField(frame: CGRect(x: 72, y: 105, width: 287, height: 44))
                    let locationTextEdit = UITextField(frame: CGRect(x: 72, y: 175, width: 287, height: 44))
                    
                    urlTextEdit.delegate = self
                    dateTimeTextEdit.delegate = self
                    locationTextEdit.delegate = self
                    
                    urlTextEdit.text = globalMessage.url?.absoluteString ?? "None"
                    dateTimeTextEdit.text = globalMessage.date.day ?? "None"
                    locationTextEdit.text = globalMessage.location ?? "None"
                    
                    urlTextEdit.tag = 503
                    dateTimeTextEdit.tag = 504
                    locationTextEdit.tag = 505
                    
                    let color = UIColor(red: 0, green: 119/255, blue: 1, alpha: 1)
                    
                    urlTextEdit.textColor = color
                    dateTimeTextEdit.textColor = color
                    locationTextEdit.textColor = color
                    
                    cell.contentView.addSubview(url)
                    cell.contentView.addSubview(dateTime)
                    cell.contentView.addSubview(location)
                    
                    cell.contentView.addSubview(urlTextEdit)
                    cell.contentView.addSubview(dateTimeTextEdit)
                    cell.contentView.addSubview(locationTextEdit)
                    
                    return cell
                    
                case 3:
                    
                    let cell = UITableViewCell()
                    cell.selectionStyle = .none
                    tableView.separatorStyle = .none
                    
                    let label = UILabel(frame: CGRect(x: 72, y: 15, width: 287, height: 66))
                    label.numberOfLines = 0
                    label.text = "Global Messages are added to the queue and will automatically loop"
                    label.textColor = .black
                    label.font = UIFont.systemFont(ofSize: 17)
                    
                    cell.contentView.addSubview(label)
                    
                    return cell
                    
                case 4:
                    
                    let cell = UITableViewCell()
                    cell.selectionStyle = .none
                    tableView.separatorStyle = .singleLine
                    
                    let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: cell.contentView.frame.height))
                    button.setTitle("Delete Prop", for: .normal)
                    button.setTitleColor(.red, for: .normal)
                    
                    button.addTarget(self, action: #selector(remove), for: .touchUpInside)

                    cell.contentView.addSubview(button)
                    
                    return cell
                    
                case 5:
                    
                    let cell = UITableViewCell()
                    cell.selectionStyle = .none
                    tableView.separatorStyle = .singleLine
                    
                    let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: cell.contentView.frame.height))
                    button.setTitle("Something's wrong?", for: .normal)
                    button.setTitleColor(UIColor(red: 0, green: 119/255, blue: 1, alpha: 1), for: .normal)
                    button.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
                    
                    cell.contentView.addSubview(button)
                    
                    return cell
                    
                default:
                    return UITableViewCell()
                }
                
            case .Timer:
                return UITableViewCell()
            }
            
        }
    }
}

extension SummaryViewController: UICollectionViewDataSource{
    
    // MARK: - UICollectionViewDataSource
    
    /**
     ## UICollectionViewDataSource - numberOfItemsInSection Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let keynote = keynote{
            return keynote.image!.count
        }else{
            return 0
        }
    }
    
    /**
     ## UICollectionViewDataSource - cellForItemAt Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let keynote = keynote{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            cell.frame.size = CGSize(width: 277, height: 151)
            
            cell.layer.cornerRadius = 5
            cell.clipsToBounds = true
            cell.contentView.backgroundColor = .lightGray
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 277, height: 151))
            imageView.image = keynote.image![indexPath.item]
            imageView.contentMode = .scaleAspectFit
            
            cell.contentView.addSubview(imageView)
            return cell
            
        }else{
            return UICollectionViewCell()
        }
    }
}
