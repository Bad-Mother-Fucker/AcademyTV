//
//  SummaryTableViewController.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 16/01/2019.
//  Copyright © 2019 Gianluca Orpello. All rights reserved.
//

import UIKit

/**
 ## Summary View Controller with the goal of manage all the information of each props.
 
 - Version: 1.0
 
 - Author: @GianlucaOrpello
 */
class SummaryViewController: UIViewController{
    
    var prop: CloudStored?
    
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
     * Add the UIBarButtonItem
     * Add the Table View
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Summary"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dissmissController))
        
        let tableView = UITableView(frame: self.view.frame)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    /**
     ## Dissmiss the Summary View controller and remove the navigation bar.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @objc func dissmissController(){
        self.dismiss(animated: true) {
            self.navigationController!.popViewController(animated: true)
        }
    }
}

extension SummaryViewController: UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - UITableViewDelegate
    
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
