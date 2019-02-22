//
//  LiveViewController.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 12/01/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//
import UIKit
import MessageUI
import CloudKit

/**
 ## The Home screen view controller.
 
 - Version: 1.1
 
 - Author: @GianlucaOrpello
 */
class LiveViewController: UIViewController, MFMailComposeViewControllerDelegate {

    /**
     ## UIRefreshControl of the tableView

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()

    /**
     ## The main tableView

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var tableView: UITableView?

    /**
     ## The main tableView

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    var spinner: UIActivityIndicatorView?

    /**
     ## Number of item of the table view

     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var numberOfObject: Int = 0 {
        didSet{
            debugPrint(numberOfObject)
            guard numberOfObject == 0 else { return }
            for view in self.view.subviews{
                view.removeFromSuperview()
            }
            loadCurrentView()
        }
    }
    
    /**
     ## All the global message airing.
    
     - Todo: Try to pass this information inside all the application.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var globalMessages: [GlobalMessage]? = [GlobalMessage]()
    var filteredGlobalMessages: [GlobalMessage]?
    
    /**
     ## All the ticker message airing.
     
     - Todo: Try to pass this information inside all the application.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var tickerMessage: [(message: String, tvName: String, TVGroup: [TVGroup]?)]? = [(message: String, tvName: String, TVGroup: [TVGroup]?)]()
    var filteredThikerMessage: [(message: String, tvName: String, TVGroup: [TVGroup]?)]?
    /**
     ## All the keynote airing.
     
     - Todo: Try to pass this information inside all the application.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var contentViewers: [(image: [UIImage]?, tvName: String, TVGroup: [TVGroup]?)]? = [(image: [UIImage]?, tvName: String, TVGroup: [TVGroup]?)]()
    var filteredKeynote: [(image: [UIImage]?, tvName: String, TVGroup: [TVGroup]?)]?

    /**
     ## UIVIewController - View did Load Methods
     
     - Version: 1.1
     
     - Author: @GianlucaOrpello
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        addLiveViewObserver()
        spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner?.color = self.view.tintColor
        spinner?.translatesAutoresizingMaskIntoConstraints = false
        spinner?.startAnimating()
        view.addSubview(spinner!)

        spinner?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }


    /**
     ## UIVIewController - ViewDidAppear Methods
     
     Used to add the object inside the view.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAiringProp(completionHandler: { [weak self] in
            self?.countNumberOfPromp()
            self?.loadCurrentView()
        })
    }

    /**
     ## UIVIewController - viewDidDisappear Methods

     Used for add the object inside the view.

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: CKNotificationName.tvSet.rawValue),
                                                  object: nil)

        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: CKNotificationName.globalMessages.rawValue),
                                                  object: nil)
    }

    /**
     ## Load the current View Methods

     Used for add the object inside the view.

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    private func loadCurrentView(){
        spinner?.stopAnimating()
        for view in self.view.subviews{
            view.removeFromSuperview()
        }
        if numberOfObject == 0 {
            let noLiveView = NoLivePrompView(frame: self.view.frame)
            noLiveView.contactbutton.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
            print(numberOfObject)
            self.view.addSubview(noLiveView)
        } else {
            for views in self.view.subviews {
                views.removeFromSuperview()
            }

            tableView = UITableView(frame: self.view.frame)
            tableView!.delegate = self
            tableView!.dataSource = self
            tableView!.tableFooterView = UIView()
            tableView!.tintColor = UIColor(red: 0, green: 119 / 255, blue: 1, alpha: 1)

            tableView!.register(TitleSubtitleAndDescriptionTableViewCell.self, forCellReuseIdentifier: "TitleSubtitleAndDescriptionTableViewCell")
            tableView!.register(TitleAndSubtitleTableViewCell.self, forCellReuseIdentifier: "TitleAndSubtitleTableViewCell")
            tableView!.register(CenteredButtonTableViewCell.self, forCellReuseIdentifier: "CenteredButtonTableViewCell")
            tableView?.refreshControl = refreshControl

            self.view.addSubview(tableView!)
        }
    }
    
    /**
     ## Bar Button Item action for add new prop.

     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @IBAction private func addNewProp(_ sender: UIBarButtonItem) {
        let destination = PropsViewController()
        let nav = UINavigationController(rootViewController: destination)
        nav.navigationBar.prefersLargeTitles = true
                
        self.present(nav, animated: true, completion: nil)
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
            mail.setToRecipients(["theappteam@icloud.com"])
            mail.setSubject("Feedback for Project Viewer")
            
            present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: "Ops...", message: "There is an error with the network, please contact a manager.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /**
     ## Implememntation of the MailComposeViewController
     
     - Version: 1.0
     
     - Author: @Afandrefe
     */
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case MFMailComposeResult.sent:
            NSLog("You sent the email.")
        case MFMailComposeResult.saved:
            NSLog("You saved a draft of this email")
        case MFMailComposeResult.cancelled:
            NSLog("You cancelled sending this email.")
        case MFMailComposeResult.failed:
            NSLog("Mail failed:  An error occurred when trying to compose this email")
        default:
            NSLog("An error occurred when trying to compose this email")
        }
        controller.dismiss(animated: true)
    }

    /**
     ## Get all the Airing Props

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    @objc func getAiringProp(completionHandler: @escaping () -> Void) {

        let ticker = CKController.getAiringTickers(in: .all)
        let keynoteFiles = CKController.getAiringKeynote(in: .all)

        contentViewers = []
        tickerMessage = []

        var uniqueTickerMessages = Set<String>()

        for tick in ticker {
            // FIXME: Group tickers by message
            uniqueTickerMessages.insert(tick.0)
            print(tick.1)
//            tickerMessage?.append((message: tick.0, tvName: tick.1, TVGroup: nil))
        }

        for message in uniqueTickerMessages {
            tickerMessage?.append((message: message, tvName: "", TVGroup: nil))
            for tick in ticker {
                if tick.0 == message {
                    let size = tickerMessage!.count
                    tickerMessage![size - 1].tvName.append(tick.1 + ", ")
                }
                //Remove last two digits
                let size = tickerMessage!.count
                if let ticker = tickerMessage?[size - 1]{
                    if ticker.tvName.count > 2 {
                        tickerMessage![size - 1].tvName.removeLast(2)
                    }
                }
            }
        }


        for key in keynoteFiles {
            contentViewers?.append((image: key.image, tvName: key.tvName, TVGroup: nil))
        }

        do{
            globalMessages = try CKController.getAllGlobalMessages(completionHandler: {
                NSLog("Get GLobal Message")
            })
        } catch {
            NSLog("Error getting the messages.")
            numberOfObject = 0
        }
        completionHandler()
    }

    private func countNumberOfPromp(){
        self.numberOfObject = 0
        numberOfObject += tickerMessage?.count ?? 0
        numberOfObject += globalMessages?.count ?? 0
        numberOfObject += contentViewers?.count ?? 0
    }

    @objc private func addNewPropFromSummay(_ notification: Notification){
        let prop = notification.userInfo?["prop"]
        if let ticker = prop as? (message: String, tvName: String, TVGroup: [TVGroup]?){
            tickerMessage?.append(ticker)
        }else if let contentViewer = prop as? (image: [UIImage]?, tvName: String, TVGroup: [TVGroup]?){
            contentViewers!.append(contentViewer)
        }else if let message = prop as? GlobalMessage{
            globalMessages?.append(message)
        }
        numberOfObject += 1
        self.tableView?.reloadData()
    }

    /**
     ## Handle the pull to refresh

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getAiringProp(completionHandler: {
            self.tableView?.reloadData()
            refreshControl.endRefreshing()
        })
    }

    private func addLiveViewObserver(){

        NotificationCenter.default.addObserver(self, selector: #selector(addNewPropFromSummay(_:)), name: .addNewPropsFromSummary, object: nil)

        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: CKNotificationName.tv.rawValue), object: nil, queue: .main) { _ in
            debugPrint("Tv update")
            let indexSet: IndexSet = [0, 1]
            self.tableView?.reloadSections(indexSet, with: .automatic)
        }

        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: CKNotificationName.globalMessages.rawValue), object: nil, queue: .main) { notification in

            if let userInfo = notification.userInfo{
                let ckqn = userInfo[CKNotificationName.notification.rawValue] as! CKQueryNotification
                guard let recordID = ckqn.recordID else { return }

                switch ckqn.queryNotificationReason {
                case .recordCreated:

                    CKKeys.database.fetch(withRecordID: recordID) { (record, error) in
                        guard record != nil, error == nil else {
                            if let ckError = error as? CKError {
                                let errorCode = ckError.errorCode
                                print(CKError.Code(rawValue: errorCode).debugDescription)
                            }
                            return

                        }
                        let msg = GlobalMessage(record: record!)
                        self.globalMessages?.insert(msg, at: 0)
                        DispatchQueue.main.async { [weak self] in
                            let indexSet: IndexSet = [2]
                            self?.tableView?.reloadSections(indexSet, with: .automatic)
                        }
                    }

                case .recordUpdated:
                    CKKeys.database.fetch(withRecordID: recordID) { (record, error) in
                        guard record != nil, error == nil else { return }
                        let msg = GlobalMessage(record: record!)
                        self.globalMessages = self.globalMessages?.map({ (currentMessage) -> GlobalMessage in
                            if currentMessage.record.recordID == msg.record.recordID{
                                return msg
                            } else{
                                return currentMessage
                            }
                        })
                        DispatchQueue.main.async {
                            let indexSet: IndexSet = [2]
                            self.tableView?.reloadSections(indexSet, with: .automatic)
                        }
                    }
                case .recordDeleted:
                    self.globalMessages = self.globalMessages?.filter({ (msg) -> Bool in
                        debugPrint("Global message deleated with id: \(recordID)")
                        return msg.record.recordID != recordID
                    })
                    let indexSet: IndexSet = [2]
                    self.tableView?.reloadSections(indexSet, with: .automatic)
                }
            }
        }
    }
}
/**
 ## LiveViewController - Inplement the Table View delegate and datasource.
 
 - Version: 1.0
 
 - Author: @GianlucaOrpello
 */
extension LiveViewController: UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - UITableView Delegate
    
    /**
     ## UITableViewDelegate - heightForRowAt Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 73
        case 0, 2:
            return 95
        default:
            return 60
        }
    }
    /**
     ## UITableViewDelegate - canEditRowAt Methods

     - Todo: Remove the selected data from CK

     - Version: 1.0

     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 3 ? false : true
    }
    
    /**
     ## UITableViewDelegate - editActionsForRowAt Methods
     
     - Todo: Remove the selected data from CK
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard indexPath.section != 3 else { return nil }

        let remove = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (_, indexPath) in

            let alert = UIAlertController(title: "Delete Prop", message: "The prop will be removed from all the screens. This cannot be undone.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let delete = UIAlertAction(title: "Delete", style: .cancel, handler: { [weak self] _ in

                switch indexPath.section {
                case 0:
                    let tickersToDelete = self?.tickerMessage![indexPath.row].tvName.replacingOccurrences(of: ", ", with: "$").split(separator: "$")
                    for tickerTVName in tickersToDelete!{
                        CKController.removeTickerMessage(fromTVNamed: (String(tickerTVName)))
                    }
                    self?.tickerMessage?.remove(at: indexPath.row)
                case 1:
                    CKController.removeKeynote(FromTV: (self?.contentViewers![indexPath.row].tvName)!)
                    self?.contentViewers!.remove(at: indexPath.row)
                case 2:
                    CKController.remove(globalMessage: (self?.globalMessages![indexPath.row])!)
                    self?.globalMessages!.remove(at: indexPath.row)
                default:
                    break
                }
                self?.numberOfObject -= 1
                tableView.reloadData()
            })
            
            alert.addAction(cancel)
            alert.addAction(delete)
            
            self?.present(alert, animated: true, completion: nil)
        }
        
        remove.backgroundColor = .red
        return [remove]
    }
    
    /**
     ## UITableViewDelegate - titleForHeaderInSection Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return tickerMessage?.count != 0 ? Categories.tickerMessage.rawValue : nil
        case 1:
            return contentViewers?.count != 0 ? Categories.keynoteViewer.rawValue : nil
        case 2:
            return globalMessages?.count != 0 ? Categories.globalMessage.rawValue : nil
        default:
            return nil
        }
    }
    
    /**
     ## UITableViewDelegate - accessoryButtonTappedForRowWith Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let destination = SummaryViewController()
        let nav = UINavigationController(rootViewController: destination)
        nav.navigationBar.prefersLargeTitles = true
        
        destination.prop = getProp(from: indexPath)
        
        self.present(nav, animated: true, completion: nil)
    }
    
    /**
     ## Get the prop of the table view cell with the indexPath.
     
     - Parameters:
        - indexPath: The current indexPath of the TableView.
     
     - Return: The element that is inside the cell.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    private func getProp(from indexPath: IndexPath) -> Any? {
        switch indexPath.section {
        case 0:
            return tickerMessage?[indexPath.row]
        case 1:
            return contentViewers?[indexPath.row]
        case 2:
            return globalMessages?[indexPath.row]
        default:
            return nil
        }
    }
    
    // MARK: - UITableView Data Source
    
    /**
     ## UITableViewDataSource - numberOfSections Methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    /**
     ## UITableViewDataSource - numberOfRowsInSection Methods
     
     - Todo: Add the minnsing information fro keynote and timer
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return tickerMessage?.count ?? 0
        case 1:
            return contentViewers?.count ?? 0
        case 2:
            return globalMessages?.count ?? 0
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    /**
     ## UITableViewDataSource - cellForRowAt Methods
     
     - Todo: Add the other cell
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
//
//            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TitleAndSubtitleTableViewCell")
//            cell.accessoryType = .detailButton
//            cell.selectionStyle = .none
//            cell.textLabel?.text = thikerMessage?[indexPath.row].message
//            cell.detailTextLabel?.text = thikerMessage?[indexPath.row].tvName
//            return cell

            if let cell = tableView.dequeueReusableCell(withIdentifier: "TitleAndSubtitleTableViewCell") as? TitleAndSubtitleTableViewCell{

                cell.title = tickerMessage?[indexPath.row].message
                cell.subtitle = tickerMessage?[indexPath.row].tvName

                return cell

            } else { return UITableViewCell() }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TitleAndSubtitleTableViewCell") as? TitleAndSubtitleTableViewCell{

                cell.title = "Unnamed"
                cell.subtitle = contentViewers?[indexPath.row].tvName

                return cell
            } else { return UITableViewCell() }
            
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TitleSubtitleAndDescriptionTableViewCell") as? TitleSubtitleAndDescriptionTableViewCell{

                cell.title = globalMessages?[indexPath.row].title
                cell.subtitle = globalMessages?[indexPath.row].subtitle
                cell.descriptions = "Everywhere"

                return cell
            } else { return UITableViewCell() }
            
        case 3:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CenteredButtonTableViewCell") as? CenteredButtonTableViewCell{

                tableView.separatorStyle = .none
                cell.title = "Something's wrong?"
                cell.titleColor = UIColor(red: 0, green: 119 / 255, blue: 1, alpha: 1)
                cell.addTarget(self, action: #selector(sendEmail))

                return cell
            } else { return UITableViewCell() }
        default:
            return UITableViewCell()
        }
    }
}
