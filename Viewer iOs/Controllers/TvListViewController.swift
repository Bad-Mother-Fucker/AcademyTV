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
    var selectedGroups: [TVGroup]?
    var keynote: [UIImage]?
    var category: Categories?
    var tickerMessage: String?
    
    // MARK: CollectionView methods
    
    @IBOutlet private weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.allowsMultipleSelection = true
            
        }
    }
    // MARK: NextBarButton
    @IBOutlet private weak var nextBarButtonItem: UIBarButtonItem!

    @IBAction private func nextBarButtonPressed(_ sender: Any) {
        let summary = SummaryViewController()
        summary.isCheckoutMode = true
        summary.categories = category
        
        if let cat = category{
            
            switch cat{
            case Categories.TickerMessage:
                
                var tvNames: String = ""
                for group in selectedGroups!{
                    tvNames.append(group.rawValue)
                    tvNames.append(", ")
                }
                let prop = (message: tickerMessage, tvName: tvNames, TVGroup:selectedGroups)
                summary.prop = prop
                                
            case Categories.KeynoteViewer:
                
                var tvNames: String? = ""
                for group in selectedGroups!{
                    tvNames!.append(contentsOf: group.rawValue)
                }
                let prop = (image: keynote, tvName: tvNames, TVGroup: selectedGroups)
                summary.prop = prop
            default:
                break
            }

        }
        
        navigationController?.pushViewController(summary, animated: true)
        
    }
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedGroups = []
        nextBarButtonItem.isEnabled = false
    }
    
    // MARK: DelegateFlowLayout methods
    // setting correct spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if UIScreen.main.bounds.width < 414 {
            return UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        } else {
            return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if UIScreen.main.bounds.width < 414{
            return 43
        } else {
            return 28
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat
        let height: CGFloat
        
        //iPhone 8, X, Xs
        if UIScreen.main.bounds.width < 414{
            if indexPath.item < 1 {
                width = 345
                height = 45
            } else {
                width = 146
                height = 95
            }
        } else { //Xr...
            if indexPath.item < 1 {
                width = 384
                height = 45
            } else {
                width = 178
                height = 95
            }
        }
    
        
        return CGSize(width: width, height: height)
    }
    
    // MARK: CollectionView Delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item > 0{
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TVGroup", for: indexPath) as? GroupsCollectionViewCell
            
            let group = groups[indexPath.item - 1]
    
            cell?.setGradientBackground(form: UIColor(red: CGFloat(group.startingColor.red/255),
                                                     green: CGFloat(group.startingColor.green/255),
                                                     blue: CGFloat(group.startingColor.blue/255),
                                                     alpha: 1),
                                       to: UIColor(red: CGFloat(group.endingColor.red/255),
                                                   green: CGFloat(group.endingColor.green/255),
                                                   blue: CGFloat(group.endingColor.blue/255),
                                                   alpha: 1))
            
            cell?.groupNameLabel.text = group.name.rawValue

            return cell ?? GroupsCollectionViewCell()
            
        } else {
            let borderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAllTVGroup", for: indexPath) as? BorderCollectionViewCell
            if UIScreen.main.bounds.width < 414{
                borderCell?.frame.size = CGSize(width: 335, height: 45)
            } else {
                borderCell?.frame.size = CGSize(width: 384, height: 45)
            }
            
            borderCell?.titleLabel.text = "Select All"
            return borderCell ?? BorderCollectionViewCell()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        if cell?.reuseIdentifier == "TVGroup"{
            cell!.isSelected = true
            selectedGroups!.append(groups[indexPath.item - 1].name)
        } else {
            for i in 1..<collectionView.numberOfItems(inSection: 0){
                collectionView.selectItem(at: IndexPath(item: i, section: 0), animated: true, scrollPosition: .bottom)
            }
            selectedGroups!.removeAll()
            for group in groups {
                
                selectedGroups!.append(group.name)
            }
            
            
        }
        
        if selectedGroups!.isEmpty {
            nextBarButtonItem.isEnabled = false
        } else {
            nextBarButtonItem.isEnabled = true
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        if cell?.reuseIdentifier == "TVGroup"{
            cell!.isSelected = false
            selectedGroups = selectedGroups!.filter { (tvGroup) -> Bool in
                if tvGroup == groups[indexPath.item - 1].name{
                    return false
                } else {
                    return true
                }
            }
        } else {
            for i in 1..<collectionView.numberOfItems(inSection: 0){
                collectionView.deselectItem(at: IndexPath(item: i, section: 0), animated: true)
            }
            selectedGroups!.removeAll()
        }
        if selectedGroups!.isEmpty {
            nextBarButtonItem.isEnabled = false
        } else {
            nextBarButtonItem.isEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "setTheTvSegue":
            
            if selectedGroups!.count == 0{
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
