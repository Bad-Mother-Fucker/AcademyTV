//
//  BooquableTableViewController.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 27/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

class BooquableTableViewController: UITableViewController {
    
    fileprivate let formatter = "yyyy-MM-dd"
    
    var orders = [BooquableOrder](){
        didSet{
            if self.tableView != nil{
                orders = orders.filter { (order) -> Bool in
                    let date = String(order.stopsAt.prefix(10))
                    let returnDate = get(date, with: formatter) ?? Date()
                    let today = Date()
                    return (today > returnDate)
                }
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        BooquableManager.shared.getOrders(with: .started)
        
        Timer.scheduledTimer(withTimeInterval: 60 * 60, repeats: true) { _ in
            BooquableManager.shared.getOrders(with: .started)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(addOrder(notification:)), name: NSNotification.Name("NewOrder"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getAllOrders), name: NSNotification.Name("GetAllOrders"), object: nil)
        
    }
    
    @objc private func addOrder(notification: NSNotification){
        if let order = notification.userInfo?["order"] as? BooquableOrder {
            orders.append(order)
        }
    }
    
    @objc private func getAllOrders(){
        orders = []
        BooquableManager.shared.ids.forEach { (id) in
            BooquableManager.shared.getOrder(from: id)
        }
    }
    
    fileprivate func get(_ date: String, with formatter: String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        guard let returnDate = dateFormatter.date(from: date) else {
            print("ERROR: Date conversion failed due to mismatched format.")
            return nil
        }
        return returnDate
    }
    
    fileprivate func getDifference(from start: Date, and end: Date) -> Int?{
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: start)
        let date2 = calendar.startOfDay(for: end)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BooquableTableViewCell", for: indexPath) as? LeftImageAndDescriptionTableViewCell
        
        let order = orders[indexPath.row]
        
        cell!.title = order.customerName()
        
//        let time = get(String(order.stopsAt.prefix(10)), with: formatter)
//        let days = getDifference(from: time!, and: Date())
//
//        let deviceInfo = order.getDevice()
//        cell!.leftImageView.backgroundColor = .lightGray
//        cell!.leftImageView.layer.cornerRadius = 5
//        cell!.leftImageView.clipsToBounds = true
//        cell!.leftImageView.image = UIImage(named: deviceInfo.glyph.rawValue)
//        cell!.descriptionLabel.text = deviceInfo.name + " " + String(days!)

        return cell!
    }
}
