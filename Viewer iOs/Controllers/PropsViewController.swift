//
//  PosterViewController.swift
//  Viewer
//
//  Created by Gianluca Orpello on 14/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

/**
 ## PropsViewController
 
 This class rappresent the viewController with the list of the possible props.
 
 - Version: 1.0
 
 - Author: @GianlucaOrpello
 */
class PropsViewController: UITableViewController, UISearchResultsUpdating {
    
    /**
     ## The list of possible props.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    let props: [(title: String, description: String, image: UIImage?)] = [
        /*(title: "Booqable Availability", description: "Displays a list of names that are overdue, on hold and ready for pickup", image: UIImage(named: "Booquable")),*/
        (title: Categories.globalMessage.rawValue, description: "Displays a message with title, description, date & time, location and URL", image: UIImage(named: "GlobalMessage")),
        (title: Categories.tickerMessage.rawValue, description: "Displays a short messager always visibile at the bottom of the screen", image: UIImage(named: "Ticker")),
        (title: "Content Viewer", description: "Dislays a keynote on selected area, airplay is not needed", image: UIImage(named: "Keynote"))
    ]
    
    var fileteredProp = [(title: String, description: String, image: UIImage?)]()
    
    /**
     ## UITableViewCell Identifier
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    fileprivate let identifier = "PropsTableViewCell"
    
    /**
     ## Search Bar Controller
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    let searchController = UISearchController(searchResultsController: nil)
    
    /**
     ## UIVIewController - viewDidLoad Methods
     
     * Set the Search Bar
     * Set the TableView
     * Check the extension.
     
     - Todo: Move the extension part to appDelegate, check with Andrea.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Props"
        
        tableView.tableFooterView = UIView()
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.tintColor = .lightGray

        
        self.tableView.tableHeaderView = searchController.searchBar
        fileteredProp = props
        
//        let tapAction = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
//        self.tableView.addGestureRecognizer(tapAction)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dissmissController))
    
    }
    
    /**
     ## Close the search bar on tap.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @objc func tableViewTapped(){
        searchController.isActive = false
    }
    
    /**
     ## UISearchResultsUpdating - updateSearchResults Methods.
     
     Used for filetr the data row on search bar text.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        if searchText == "" {
            fileteredProp = props
        } else {
            // Filter the results
            fileteredProp = props.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        
        self.tableView.reloadData()
    }
    
    /**
     ## Dissmiss the current View Controller.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    @objc func dissmissController(){
        self.dismiss(animated: true) {
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    // MARK: - UITableView Delegate
    
    /**
     ## UITableViewDelegate - heightForRowAt methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: UITableView Data Source
    
    /**
     ## UITableViewDataSource - numberOfRowsInSection methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileteredProp.count
    }

    /**
     ## UITableViewDataSource - cellForRowAt methods
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PropsTableViewCell()
        
        let prop = fileteredProp[indexPath.row]
        cell.leftImageView.image = prop.image
        cell.titleLabel.text = prop.title
        cell.descriptionLabel.text = prop.description
        
        return cell
    }
    
    /**
     ## UITableViewDataSource - didSelectRowAt methods
     
     - Todo: Change the implementation with the new design.
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destination = AddPropsViewController()
        let nav = self.navigationController
        nav?.navigationBar.prefersLargeTitles = true

        let prop = props[indexPath.row]
        destination.props = (title: prop.title, description: prop.description)
        nav?.pushViewController(destination, animated: true)
    }
    
}
