//
//  ShareViewController.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 10/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

var globalGroups = [
    TVGroups(name: .lab1,
             tvList: ["01", "02", "03", "04", "05", "06"],
             startingColor: (red: 56, green: 204, blue: 175),
             endingColor: (red: 0, green: 165, blue: 144)),
    TVGroups(name: .collab1,
             tvList: ["01", "02", "03", "04"],
             startingColor: (red: 251, green: 131, blue: 23),
             endingColor: (red: 255, green: 89, blue: 0)),
    TVGroups(name: .lab2,
             tvList: ["01", "02", "03", "04"],
             startingColor: (red: 240, green: 182, blue: 0),
             endingColor: (red: 230, green: 132, blue: 0)),
    TVGroups(name: .collab2,
             tvList: ["01", "02", "03", "04", "05", "06"],
             startingColor: (red: 78, green: 169, blue: 241),
             endingColor: (red: 0, green: 120, blue: 223)),
    TVGroups(name: .lab3,
             tvList: ["01", "02", "03", "04", "05", "06", "07", "08"],
             startingColor: (red: 78, green: 169, blue: 241),
             endingColor: (red: 0, green: 120, blue: 223)),
    TVGroups(name: .collab3,
             tvList: ["01", "02", "03", "04", "05", "06"],
             startingColor: (red: 251, green: 131, blue: 23),
             endingColor: (red: 225, green: 89, blue: 0)),
    TVGroups(name: .lab4,
             tvList: ["01", "02", "03", "04"],
             startingColor: (red: 240, green: 182, blue: 0),
             endingColor: (red: 230, green: 132, blue: 0)),
    TVGroups(name: .collab4,
             tvList: ["01", "02", "03", "04"],
             startingColor: (red: 56, green: 204, blue: 175),
             endingColor: (red: 0, green: 165, blue: 144)),
    TVGroups(name: .seminar,
             tvList: ["Seminar"],
             startingColor: (red: 239, green: 98, blue: 168),
             endingColor: (red: 205, green: 32, blue: 122)),
    TVGroups(name: .kitchen,
             tvList: ["Kitchen"],
             startingColor: (red: 115, green: 117, blue: 121),
             endingColor: (red: 82, green: 84, blue: 87)),
    TVGroups(name: .br1,
             tvList: ["01", "02"],
             startingColor: (red: 240, green: 182, blue: 0),
             endingColor: (red: 230, green: 132, blue: 0)),
    TVGroups(name: .br2,
             tvList: ["01", "02"],
             startingColor: (red: 56, green: 204, blue: 175),
             endingColor: (red: 0, green: 165, blue: 144)),
    TVGroups(name: .br3,
             tvList: ["01", "02"],
             startingColor: (red: 239, green: 98, blue: 168),
             endingColor: (red: 205, green: 32, blue: 122)),
    TVGroups(name: .all,
             tvList: ["01"],
             startingColor: (red: 0, green: 201, blue: 227),
             endingColor: (red: 0, green: 153, blue: 194))
]

struct TVGroups{
    var name: TVGroup
    var tvList: [String]
    var startingColor: (red: Float, green: Float, blue: Float)
    var endingColor: (red: Float, green: Float, blue: Float)
}

class TvListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPopoverPresentationControllerDelegate {
    
    var groups = globalGroups
    
    var selectedGroup: TVGroups?
    var selectedGroups = [TVGroup]()
    var image: UIImage!
    
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.allowsMultipleSelection = true
        }
    }
    
    @IBOutlet weak var clearBarButtonItem: UIBarButtonItem!{
        didSet{
            if selectedGroups != nil{
                if selectedGroups.count != 0 {
                    clearBarButtonItem.isEnabled = true
                }
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item < groups.count{
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TVGroup", for: indexPath) as! GroupsCollectionViewCell
            
            let group = groups[indexPath.item]
            
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
            selectedGroups.append(groups[indexPath.item].name)
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

