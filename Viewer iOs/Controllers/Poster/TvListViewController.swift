//
//  ShareViewController.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 10/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

class TvListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPopoverPresentationControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: Class variables
    
    var groups = globalGroups
    
    var selectedGroup: TVGroups?
    var selectedGroups = [TVGroup]()
    var image: UIImage!
    
    // MARK: CollectionView methods
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.allowsMultipleSelection = true
            
        }
    }
    
    
    
    @IBOutlet weak var clearBarButtonItem: UIBarButtonItem!{
        didSet{
                if selectedGroups.count != 0 {
                    clearBarButtonItem.isEnabled = true
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (traitCollection.forceTouchCapability == .available){
        }
        
    }
    
    @IBAction func clearKeynotes(_ sender: UIBarButtonItem) {
        for group in selectedGroups{
            CKController.removeKeynote(fromTVGroup: group)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count + 1
    }
    
    
    // setting correct spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat
        let height : CGFloat
    
        if indexPath.item < 1 {
            width = 386
            height = 45
        } else {
            width = 178
            height = 95
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item > 0{
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TVGroup", for: indexPath) as! GroupsCollectionViewCell
            
            let group = groups[indexPath.item - 1]
    
            cell.setGradientBackground(form: UIColor(red: CGFloat(group.startingColor.red/255),
                                                     green: CGFloat(group.startingColor.green/255),
                                                     blue: CGFloat(group.startingColor.blue/255),
                                                     alpha: 1),
                                       to: UIColor(red: CGFloat(group.endingColor.red/255),
                                                   green: CGFloat(group.endingColor.green/255),
                                                   blue: CGFloat(group.endingColor.blue/255),
                                                   alpha: 1))
            
            cell.groupNameLabel.text = group.name.rawValue

            return cell
            
        }else{
            let borderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAllTVGroup", for: indexPath) as! BorderCollectionViewCell
            borderCell.frame.size = CGSize(width: 386, height: 45)
            borderCell.titleLabel.text = "Select All"
            return borderCell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        if cell?.reuseIdentifier == "TVGroup"{
            cell!.isSelected = true
            selectedGroups.append(groups[indexPath.item - 1].name)
            clearBarButtonItem.isEnabled = true
        }else{
            for tvCell in collectionView.visibleCells{
                tvCell.isSelected = true
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        if cell?.reuseIdentifier == "TVGroup"{
            cell!.isSelected = false
        }else{
            for tvCell in collectionView.visibleCells{
                tvCell.isSelected = false
                selectedGroups = selectedGroups.filter { (tvGroup) -> Bool in
                    if tvGroup == groups[indexPath.item].name{
                        clearBarButtonItem.isEnabled = false
                        return false
                    }else{
                        return true
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "setTheTvSegue":
            
            if selectedGroups.count == 0{
                let alert = UIAlertController(title: "Select at least one group.", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }

            if let destination = segue.destination as? PosterViewController{
                destination.tvGroups = selectedGroups
            }

        default:
            break
        }
    }
}

