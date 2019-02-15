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

    /**
     ## The main tableView

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var tableView: UITableView!{
        didSet{
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            tableView.register(CenteredButtonTableViewCell.self, forCellReuseIdentifier: "CenteredButtonTableViewCell")
            tableView.register(TopTitleAndBottomLabelValue.self, forCellReuseIdentifier: "TopTitleAndBottomLabelValue")
            tableView.register(FullLightTextTableViewCell.self, forCellReuseIdentifier: "FullLightTextTableViewCell")
            tableView.register(ThreeLabelsAndThreeTextFieldTableViewCell.self, forCellReuseIdentifier: "ThreeLabelsAndThreeTextFieldTableViewCell")
        }
    }
    
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
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(pop))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(postProp))
        } else if categories?.rawValue == Categories.globalMessage.rawValue {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editProp))
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dissmissController))
        } else {
             self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dissmissController))
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
        // swiftlint:disable unused_optional_binding
        if let _ = prop as? (message: String, tvName: String?, TVGroup: [TVGroup]?){
            self.categories = .tickerMessage
        } else if let key = prop as? (image: [UIImage]?, tvName: String?, TVGroup: [TVGroup]?){
            self.categories = .keynoteViewer
            keynote = key
            debugPrint(keynote!)
            // swiftlint:disable unused_optional_binding
        } else if let _ = prop as? GlobalMessage{
            self.categories = .globalMessage
        }
    }
    
    
    @objc func postProp() {
        debugPrint("PostProp")
        if let cat = categories{
            switch cat {
            case Categories.tickerMessage:
                let ticker = prop as? (message: String, tvName: String, TVGroup: [TVGroup])
                ticker?.TVGroup.forEach { (group) in
                    CKController.postTickerMessage((ticker?.message)!, onTvGroup: group)
                }
            case Categories.keynoteViewer:
                let keynote = prop as? (image: [UIImage]?, tvName: String, TVGroup: [TVGroup])
                keynote?.TVGroup.forEach { (group) in
                    CKController.postKeynote(keynote?.image! ?? [UIImage()], ofType: .PNG, onTVsOfGroup: group)
                }
            case Categories.globalMessage:
                let gm = prop as? GlobalMessage
                CKController.postMessage(title: gm?.title ?? "", subtitle: (gm?.subtitle)!, location: gm?.location, date: (gm?.date)!, description: gm?.description, URL: gm?.url, timeToLive: 0)
            default:
                break
            }

        }
    }

    @objc func editProp() {
        if let cat = categories{
            switch cat {
            // FIXME: check the edit function for thicker and content view.
            case Categories.tickerMessage:
               
                break
            case Categories.keynoteViewer:
             
                break
            case Categories.globalMessage:
                let globalMessage = prop as? GlobalMessage
                globalMessage?.title = (tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.viewWithTag(500) as? UILabel)?.text ?? ""
                globalMessage?.subtitle = (tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.viewWithTag(501) as? UILabel)?.text ?? ""
                globalMessage?.location = (tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.viewWithTag(505) as? UILabel)?.text ?? ""
                globalMessage?.date.0 = (tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.viewWithTag(504) as? UITextField)?.text ?? ""
                globalMessage?.description = (tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.viewWithTag(502) as? UITextField)?.text ?? ""
                globalMessage?.url = URL(string: (tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.viewWithTag(503) as? UITextField)?.text ?? "")
                
                let operation = CKModifyRecordsOperation(recordsToSave: [(globalMessage?.record)!], recordIDsToDelete: nil)
                CKKeys.database.add(operation)
                self.navigationController?.dismiss(animated: true, completion: nil)
                
            default:
                break
            }
            
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
        let delete = UIAlertAction(title: "Delete", style: .cancel, handler: { [weak self] _ in
            
            if let ticker = self?.prop as? (message: String, tvName: String){
                CKController.removeTickerMessage(fromTVNamed: ticker.tvName)
            } else if let keynote = self?.prop as? (image: [UIImage]?, tvName: String){
                CKController.removeKeynote(FromTV: keynote.tvName)
            } else if let globalMessage = self?.prop as? GlobalMessage{
                CKController.remove(globalMessage: globalMessage)
            }
            NotificationCenter.default.post(name: NSNotification.Name("UpdateAiringPropsList"), object: nil)
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
        case .tickerMessage:
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
        case .globalMessage:
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
        case .keynoteViewer:
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
        case .timer:
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
        case .tickerMessage, .globalMessage:
            return isCheckoutMode ? 4:6
        case .keynoteViewer:
            return isCheckoutMode ? 3:5
        case .timer:
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell"){
                cell.selectionStyle = .none
                tableView.separatorStyle = .none
                switch categories!{
                case .tickerMessage:
                    cell.imageView?.image = UIImage(named: "Ticker")
                    cell.textLabel?.text = Categories.tickerMessage.rawValue
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
                case .keynoteViewer:
                    cell.imageView?.image = UIImage(named: "Keynote")
                    cell.textLabel?.text = Categories.keynoteViewer.rawValue
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
                case .globalMessage:
                    cell.imageView?.image = UIImage(named: "GlobalMessage")
                    cell.textLabel?.text = Categories.globalMessage.rawValue
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
                case .timer:
                    break
                }
                return cell
            } else { return UITableViewCell() }
        } else {
            tableView.separatorStyle = .singleLine
            switch categories!{
            // MARK: Ticker Message
            case .tickerMessage:
                // Total of 6 rows
                let tickerMessage = prop as? (message: String, tvName: String?, TVGroup: [TVGroup]?)
                
                switch indexPath.row{
                case 1:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "TopTitleAndBottomLabelValue") as? TopTitleAndBottomLabelValue{
                        cell.title = "Text"
                        cell.valueText = tickerMessage?.message
                        return cell
                    } else { return UITableViewCell() }
                case 2:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "TopTitleAndBottomLabelValue") as? TopTitleAndBottomLabelValue{
                        cell.title = "Sets"
                        var tvNamesString = String()
                        if let groups = tickerMessage?.TVGroup{
                            for tm in groups{
                                tvNamesString.append(contentsOf: tm.rawValue)
                                tvNamesString.append(contentsOf: ", ")
                            }
                            tvNamesString.removeLast(2)
                        }
                        cell.valueText = tickerMessage?.tvName
                        return cell
                    } else { return UITableViewCell() }
                case 3:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "FullLightTextTableViewCell") as? FullLightTextTableViewCell {
                        cell.fullText = "If a screen is already airing a Ticker Message, it will be erased and replaced by this one"
                        cell.fullTextColor = .black
                        cell.fullTextFont = UIFont.systemFont(ofSize: 17)
                        cell.isFullSize = false
                        return cell
                    } else { return UITableViewCell() }                    
                case 4:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "CenteredButtonTableViewCell") as? CenteredButtonTableViewCell {
                        cell.title = "Delete Prop"
                        cell.titleColor = .red
                        cell.addTarget(self, action: #selector(remove))
                        return cell
                    } else { return UITableViewCell() }
                case 5:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "CenteredButtonTableViewCell") as? CenteredButtonTableViewCell{
                        cell.title = "Something's wrong?"
                        cell.titleColor = UIColor(red: 0, green: 119/255, blue: 1, alpha: 1)
                        cell.addTarget(self, action: #selector(sendEmail))
                        return cell
                    } else { return UITableViewCell() }
                default: return UITableViewCell()
                }
            // MARK: Content Viewer
            case .keynoteViewer:
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
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "FullLightTextTableViewCell") as? FullLightTextTableViewCell {
                        cell.fullText = "Content will automatically loop if more than one file is selected"
                        cell.fullTextColor = .black
                        cell.fullTextFont = UIFont.systemFont(ofSize: 17)
                        return cell
                    } else { return UITableViewCell() }
                case 3:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "CenteredButtonTableViewCell") as? CenteredButtonTableViewCell {
                        cell.title = "Delete Prop"
                        cell.titleColor = .red
                        cell.addTarget(self, action: #selector(remove))
                        return cell
                    } else { return UITableViewCell() }
                case 4:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "CenteredButtonTableViewCell") as? CenteredButtonTableViewCell{
                        cell.title = "Something's wrong?"
                        cell.titleColor = UIColor(red: 0, green: 119/255, blue: 1, alpha: 1)
                        cell.addTarget(self, action: #selector(sendEmail))
                        return cell
                    } else { return UITableViewCell() }
                default:
                    return UITableViewCell()
                }
            //MARK: Global Message
            case .globalMessage:
                // Total of 6 rows

                let globalMessage = prop as? GlobalMessage
                
                switch indexPath.row{
                    
                case 1:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "ThreeLabelsAndThreeTextFieldTableViewCell") as? ThreeLabelsAndThreeTextFieldTableViewCell {
                        cell.firstTitle = "Title"
                        cell.secondTitle = "Subtitle"
                        cell.thirdTitle = "Text"
                        cell.firstText = globalMessage?.title
                        cell.secondText = globalMessage?.subtitle
                        cell.thirdText = globalMessage?.description
                        cell.delegate = self
                        cell.isCheckoutMode = isCheckoutMode
                        cell.textfieldTextColor = UIColor(red: 0, green: 119/255, blue: 1, alpha: 1)
                        return cell
                    } else { return UITableViewCell() }
                case 2:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "ThreeLabelsAndThreeTextFieldTableViewCell") as? ThreeLabelsAndThreeTextFieldTableViewCell {
                        cell.firstTitle = "URL"
                        cell.secondTitle = "Date & Time"
                        cell.thirdTitle = "Location"
                        cell.firstText = globalMessage?.url?.absoluteString ?? "None"
                        cell.secondText = globalMessage?.date.day ?? "None"
                        cell.thirdText = globalMessage?.location ?? "None"
                        cell.delegate = self
                        cell.isCheckoutMode = false
                        cell.textfieldTextColor = UIColor(red: 0, green: 119/255, blue: 1, alpha: 1)
                        return cell
                    } else { return UITableViewCell() }
                case 3:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "FullLightTextTableViewCell") as? FullLightTextTableViewCell {
                        cell.fullText = "Global Messages are added to the queue and will automatically loop"
                        cell.fullTextColor = .black
                        cell.fullTextFont = UIFont.systemFont(ofSize: 17)
                        return cell
                    } else { return UITableViewCell() }
                case 4:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "CenteredButtonTableViewCell") as? CenteredButtonTableViewCell {
                        cell.title = "Delete Prop"
                        cell.titleColor = .red
                        cell.addTarget(self, action: #selector(remove))
                        return cell
                    } else { return UITableViewCell() }
                case 5:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "CenteredButtonTableViewCell") as? CenteredButtonTableViewCell{
                        cell.title = "Something's wrong?"
                        cell.titleColor = UIColor(red: 0, green: 119/255, blue: 1, alpha: 1)
                        cell.addTarget(self, action: #selector(sendEmail))
                        return cell
                    } else { return UITableViewCell() }
                default: return UITableViewCell()
                }
            case .timer:
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
        } else { return 0 }
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
        } else { return UICollectionViewCell() }
    }
}
