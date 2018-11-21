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

class GlassOfficeViewController: UIViewController, UITableViewDelegate {

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
        
        BooquableManager.shared.getOrders(with: .reserved)
        
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "booquableTableViewCell", for: indexPath)
        
        return cell
    }
    
    
}
