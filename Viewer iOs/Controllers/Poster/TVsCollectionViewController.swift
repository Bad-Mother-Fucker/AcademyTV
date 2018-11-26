//
//  TVsCollectionViewController.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 26/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TVsCell"

class TVsCollectionViewController: UICollectionViewController {

    var image: UIImage!

    var tvGroups = [TVGroup]()
    var startColor: UIColor = .white
    var endColor: UIColor = .black
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }


    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tvGroups.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GroupsCollectionViewCell
    
        cell.setGradientBackground(form: startColor, to: endColor)
        cell.groupNameLabel.text = tvGroups[indexPath.item].rawValue
        
        return cell
    }

}
