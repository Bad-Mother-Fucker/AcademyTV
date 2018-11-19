//
//  SettingGroupViewController.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 12/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

class SettingGroupViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var tvs = [String](){
        didSet{
            if collectionView != nil{
                collectionView.reloadData()
            }
        }
    }
    
    var backgroungStartingColor: UIColor! = .gray
    var backgroungEndingColor: UIColor! = .blue
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [backgroungStartingColor.cgColor, backgroungEndingColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = self.collectionView.bounds
        
        self.collectionView.layer.addSublayer(gradientLayer)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(tvs.count)
        return tvs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tvsNameListCollectionViewCell", for: indexPath)
        cell.backgroundColor = .gray
        return cell
    }
}
