//
//  GlassOfficeViewController.swift
//  Viewer
//
//  Created by Gianluca Orpello on 16/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

/**
 ## UITableViewCell Extension
 
 This extension are used just for override the canBecomeFocused property of the table view cell.
 The goal is to remove the user interaction UI element
 
 - Note: Use this extension fot customize the behaviour of the Table View Cell
 
 - Version: 1.0
 
 - Author: @GianlucaOrpello, @Micheledes
 */
extension UITableViewCell {
    override open var canBecomeFocused: Bool {
        return false
    }
}

/**
 ## TVViewController
 
 This controller manage the data that need to be displayed on the Glass Office
 
 - SeeAlso: TVViewController class.
 
 - Todo: Check if Booqable data is collecting during all the day
 
 - Version: 1.0
 
 - Author: @GianlucaOrpello

 */
class GlassOfficeViewController: TVViewController, UITableViewDelegate {
    
    // MARK: - Private API
    
    /**
     ## Date formatter
   
     Specific date formatter used for display the date in the chosed way.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    fileprivate let formatter = "yyyy-MM-dd"
    
    // MARK: - Public API
    
    /**
     ## Booquable Order
     
    The list of the booquable order, filtred by the date of the end.
     
     - Todo: Check when the didSet was called, the list must me cleaned.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    var orders = [BooquableOrder]() {
        didSet {
            if booquableTableView != nil {
                orders = orders.filter { (order) -> Bool in
                    let date = String(order.stopsAt.prefix(10))
                    let returnDate = get(date, with: formatter) ?? Date()
                    let today = Date()
                    return (today > returnDate)
                }
                booquableTableView.reloadData()
            }
        }
    }
    
    // MARK: - Outlets
    
    /**
     ## Keynote ImageView
     
     Image View used for display the keynote
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @IBOutlet private weak var keynoteImageView: UIImageView!
    
    /**
     ## Order Table View
     
     Table View used for display the booquable order list.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @IBOutlet private weak var booquableTableView: UITableView! {
        didSet {
            booquableTableView.delegate = self
            booquableTableView.dataSource = self
        }
    }
    
    /**
     ## Date Label
     
     Label used for display the currwnt date.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @IBOutlet private weak var dateLabel: UILabel! {
        didSet {
            setDate()
            Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
                self?.setDate()
            }
        }
    }
    
    /**
     ## visual Effect View
     
     View used for create the blur effect.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @IBOutlet private weak var blurEffect: UIVisualEffectView! {
        didSet {
            blurEffect.layer.cornerRadius = 20
            blurEffect.contentView.layer.cornerRadius = 20
            blurEffect.clipsToBounds = true
            blurEffect.contentView.clipsToBounds = true
            blurEffect.alpha = 0.8
        }
    }
    
    // MARK: - View Controller life cylce
    
    /**
     ## viewDidAppear method implementation
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     
     - Todo: Check the observer beheviours, maybe they need to be release at the and of the life of the controller.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       // self.currentTV = (UIApplication.shared.delegate as? AppDelegate).currentTV
        //self.currentTV.keynoteDelegate = self
        
        BooquableManager.shared.getOrders(with: .started)
        
        Timer.scheduledTimer(withTimeInterval: 60 * 60, repeats: true) { _ in
            BooquableManager.shared.getOrders(with: .started)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(addOrder(notification:)), name: NSNotification.Name("NewOrder"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getAllOrders), name: NSNotification.Name("GetAllOrders"), object: nil)
        
        NotificationCenter.default.addObserver(forName: Notification.Name(CKNotificationName.tvSet.rawValue), object: nil, queue: .main) { _ in
            self.currentTV = (UIApplication.shared.delegate as? AppDelegate)?.currentTV
            self.currentTV.viewDelegate = self
        }

    }
    
    /**
     ## Add Order inside the array list of the table view
     
     This function are created for append a new element inside the array list. this function are called with a notification every time that booquable return a new element.
     
     - Parameters:
        - notification: NSNotification that call this function
     
     - SeeAlso: For more info see the [Booquable Documentation](https://booqable.com/blog/booqable-api-documentation/)
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @objc private func addOrder(notification: NSNotification) {
        if let order = notification.userInfo?["order"] as? BooquableOrder {
            orders.append(order)
        }
    }
    
    /**
     ## Get All the order from Booquable
     
     This function are created for gett all the current order from Booquable
     
     - SeeAlso: For more info see the [Booquable Documentation](https://booqable.com/blog/booqable-api-documentation/)
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @objc private func getAllOrders() {
        orders = []
        BooquableManager.shared.ids.forEach { (id) in
            BooquableManager.shared.getOrder(from: id)
        }
    }
    
    // MARK: - Private Implementation
    
    /**
     ## Set Date label of the tv
     
     Update the time every minute and set as text inside the label
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    private func setDate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, HH:mm"
        
        self.dateLabel.text = dateFormatter.string(from: date)
    }
    
    /**
     ## Get the date with a specific formatter.
     
     Get a date instance and return it formatted in the choosen way.
     
     - Parameters:
        - date: The current date in String format.
        - formatter: The formatter to apply at the date in String format.
     
     - Return: Return the date formatted.
     
     - Warning: Can fail if the date couldn't be formatted.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    fileprivate func get(_ date: String, with formatter: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        guard let returnDate = dateFormatter.date(from: date) else {
            print("ERROR: Date conversion failed due to mismatched format.")
            return nil
        }
        return returnDate
    }
    
    /**
     ## Get the number of days between two days
     
     This function can return the numbers of days between two dates. This are used for calculate if you have to return a device.
     
     - Parameters:
        - start: The first date
        - end: The second date
     
     - Return: The number of days passed between the two dates
    
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    fileprivate func getDifference(from start: Date, and end: Date) -> Int? {
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: start)
        let date2 = calendar.startOfDay(for: end)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day
    }
}

// MARK: - UITableViewDataSource Implementation

/**
 ## Extension created for implement the data source protocol for the table view.
 
 - Remark: Extension
 
 - Version: 1.0
 
 - Author: @GianlucaOrpello
 */
extension GlassOfficeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "booquableTableViewCell", for: indexPath) as? GlassOfficeTableViewCell {
            cell.userName = orders[indexPath.row].customerName()
            let deviceInfo = orders[indexPath.row].getDevice()
            cell.deviceName = deviceInfo.name
            cell.device = UIImage(named: deviceInfo.glyph.rawValue)

            let time = get(String(orders[indexPath.row].stopsAt.prefix(10)), with: formatter)
            let days = getDifference(from: time!, and: Date())
            cell.timingInformation = String(days!)

            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

// TODO: - Document this part
// MARK: - ATVViewDelegate Implementation
extension GlassOfficeViewController: ATVViewDelegate {
    func show(ticker: String) {
        
    }
    
    func hideTicker() {
        
    }
    
    func show(keynote: [UIImage]) {
        //        Perform UI Keynote  Showing
        self.keynoteImageView.image = keynote[0]
        
    }
    
    func hideKeynote() {
        //        Perform UI Keynote hiding
        self.keynoteImageView.image = nil
    }
}
