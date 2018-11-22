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

enum GliphName: String{
    case appleWatch = "Apple Watch"
    case applePencil = "Apple Pencil"
    case appleTV = "Apple TV"
    case ipadMini = "iPad Mini"
    case ipadPro = "iPad Pro"
    case iphone8 = "iPhone 8"
    case iphoneX = "iPhone X"
    case macMini = "Mac Mini"
}

class GlassOfficeViewController: UIViewController, UITableViewDelegate {
    
    var orders = [BooquableOrder](){
        didSet{
            if booquableTableView != nil{
                orders.filter { (order) -> Bool in
                    let date = String(order.stopsAt.prefix(10))
                    print(date)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    guard let returnDate = dateFormatter.date(from: date) else {
                        fatalError("ERROR: Date conversion failed due to mismatched format.")
                    }
                    let today = Date()
                    return (today > returnDate)
                }
                booquableTableView.reloadData()
            }
        }
    }
    
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
        
        BooquableManager.shared.getOrders(with: .started)
        
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
    
    private func setDate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, HH:mm"
        
        self.dateLabel.text = dateFormatter.string(from: date)
    }
}

extension GlassOfficeViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "booquableTableViewCell", for: indexPath) as! GlassOfficeTableViewCell
        cell.userNameLabel.text = orders[indexPath.row].customerName()
        cell.deviceNameLabel.text = orders[indexPath.row].getDeviceName()
        return cell
    }
}
