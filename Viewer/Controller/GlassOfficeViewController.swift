//
//  GlassOfficeViewController.swift
//  Viewer
//
//  Created by Gianluca Orpello on 16/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

extension UITableViewCell{
    override open var canBecomeFocused: Bool{
        return false
    }
}

class GlassOfficeViewController: TVViewController, UITableViewDelegate {
    
    fileprivate let formatter = "yyyy-MM-dd"
    
    var orders = [BooquableOrder](){
        didSet{
            if booquableTableView != nil{
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
    
    @IBOutlet weak var keynoteImageView: UIImageView!
    @IBOutlet weak var booquableTableView: UITableView!{
        didSet{
            booquableTableView.delegate = self
            booquableTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!{
        didSet{
            setDate()
            Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] (timer) in
                self?.setDate()
            }
        }
    }
    
    @IBOutlet weak var blurEffect: UIVisualEffectView!{
        didSet{
            blurEffect.layer.cornerRadius = 20
            blurEffect.contentView.layer.cornerRadius = 20
            blurEffect.clipsToBounds = true
            blurEffect.contentView.clipsToBounds = true
            blurEffect.alpha = 0.8
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       // self.currentTV = (UIApplication.shared.delegate as! AppDelegate).currentTV
        //self.currentTV.keynoteDelegate = self
        
        BooquableManager.shared.getOrders(with: .started)
        
        Timer.scheduledTimer(withTimeInterval: 60*60, repeats: true) { (timer) in
            BooquableManager.shared.getOrders(with: .started)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(addOrder(notification:)), name: NSNotification.Name("NewOrder"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getAllOrders), name: NSNotification.Name("GetAllOrders"), object: nil)
        
        NotificationCenter.default.addObserver(forName: Notification.Name(CKNotificationName.tvSet.rawValue), object: nil, queue: .main) { (notification) in
            self.currentTV = (UIApplication.shared.delegate as! AppDelegate).currentTV
            self.currentTV.viewDelegate = self
        }

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
    
    private func setDate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, HH:mm"
        
        self.dateLabel.text = dateFormatter.string(from: date)
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
}

extension GlassOfficeViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "booquableTableViewCell", for: indexPath) as! GlassOfficeTableViewCell
        cell.userNameLabel.text = orders[indexPath.row].customerName()
        let deviceInfo = orders[indexPath.row].getDevice()
        cell.deviceNameLabel.text = deviceInfo.name
        cell.deviceImage.image = UIImage(named: deviceInfo.glyph.rawValue)
        
        let time = get(String(orders[indexPath.row].stopsAt.prefix(10)), with: formatter)
        let days = getDifference(from: time!, and: Date())
        cell.timingInformationLabel.text = String(days!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

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

