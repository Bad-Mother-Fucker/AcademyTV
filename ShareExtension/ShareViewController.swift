//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Gianluca Orpello on 22/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit
import MobileCoreServices
import Social


class ShareViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPopoverPresentationControllerDelegate {
    
    var groups = globalGroups
    
    var selectedGroup: TVGroupCellData?
    var selectedGroups = [TVGroup]()
    var image: UIImage!
    
    var shareExtensionContext: NSExtensionContext?

    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.allowsMultipleSelection = true
        }
    }
    
    @IBOutlet private weak var clearBarButtonItem: UIBarButtonItem! {
        didSet {
            if selectedGroups.count != 0 {
                clearBarButtonItem.isEnabled = true
            }
        }
    }
    

    @IBAction private func cancelShare(_ sender: Any) {
        self.shareExtensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shareExtensionContext = ExtensionContextContainer.shared.context
        
        if traitCollection.forceTouchCapability == .available {
        }
        
    }
    
    @IBAction private func clearKeynotes(_ sender: UIBarButtonItem) {
        for group in selectedGroups {
            CKController.removeKeynote(fromTVGroup: group)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item < groups.count{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TVGroup", for: indexPath) as? GroupsCollectionViewCell {
                let group = groups[indexPath.item]

                cell.setGradientBackground(form: UIColor(red: CGFloat(group.startingColor.red / 255),
                                                          green: CGFloat(group.startingColor.green / 255),
                                                          blue: CGFloat(group.startingColor.blue / 255),
                                                          alpha: 1),
                                            to: UIColor(red: CGFloat(group.endingColor.red / 255),
                                                        green: CGFloat(group.endingColor.green / 255),
                                                        blue: CGFloat(group.endingColor.blue / 255),
                                                        alpha: 1))

                cell.groupName = group.name.rawValue

                return cell
            } else { return UICollectionViewCell() }
            

        } else {
            guard let borderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAllTVGroup", for: indexPath) as? BorderCollectionViewCell else { return UICollectionViewCell() }
            borderCell.frame.size = CGSize(width: 343, height: 43)
            borderCell.titleText = "Select All"
            return borderCell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        if cell?.reuseIdentifier == "TVGroup"{
            cell!.isSelected = true
            selectedGroups.append(groups[indexPath.item].name)
            clearBarButtonItem.isEnabled = true
        } else {
            for tvCell in collectionView.visibleCells {
                tvCell.isSelected = true
            }
            collectionView.reloadData()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        if cell?.reuseIdentifier == "TVGroup"{
            cell!.isSelected = false
        } else {
            for tvCell in collectionView.visibleCells {
                tvCell.isSelected = false
                selectedGroups = selectedGroups.filter { (tvGroup) -> Bool in
                    if tvGroup == groups[indexPath.item].name {
                        clearBarButtonItem.isEnabled = false
                        return false
                    } else {
                        return true
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "setTheTvSegue":
            
            if selectedGroups.count == 0 {
                let alert = UIAlertController(title: "Select at least one group.", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if let destination = segue.destination as? SharePosterViewController {
                destination.tvGroups = selectedGroups
                destination.shareExtensionContext = self.shareExtensionContext
            }
            
        default:
            break
        }
    }


func shareContent(_ sender: Any) {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        
        let UTI = kUTTypeImage as String
    if let item = self.shareExtensionContext?.inputItems[0] as? NSExtensionItem {
            var keynoteData: [Data] = []
            for element in item.attachments! {
                let itemProvider = element
                
                if itemProvider.hasItemConformingToTypeIdentifier(UTI) {
                    
                    //                    NSLog("itemprovider: %@", itemProvider)
                    itemProvider.loadItem(forTypeIdentifier: UTI, options: nil, completionHandler: { (item, error) in
                        
                        if error != nil {
                            print("there was an error", error!.localizedDescription)
                        }
                        
                        var imgData: Data!
                        if let url = item as? URL {
                            do {
                                imgData = try Data(contentsOf: url)
                            } catch {
                                NSLog("Error getting imgData - ShareViewController: shareContent")
                            }
                        }
                        
                        if let img = item as? UIImage {
                            imgData = img.jpegData(compressionQuality: 1)
                        }
                        
                        
                        //                        let userDefault = UserDefaults.standard
                        //                        userDefault.addSuite(named: "com.Rogue.Viewer.ShareExt")
                        //                        userDefault.set(imgData, forKey: "keynote")
                        //                        userDefault.synchronize()
                        keynoteData.append(imgData)
                        
                    })
                } else if itemProvider.hasItemConformingToTypeIdentifier("public.png") {
                    //                    NSLog("itemprovider: %@", itemProvider)
                    itemProvider.loadItem(forTypeIdentifier: "public.png", options: nil, completionHandler: { (item, error) in
                        
                        if error != nil {
                            print("there was an error", error!.localizedDescription)
                        }

                        var imgData: Data!
                        if let url = item as? URL {
                            do {
                                imgData = try Data(contentsOf: url)
                            } catch {
                                NSLog("Error getting imgData - ShareViewController: shareContent")
                            }
                        }
                        
                        if let img = item as? UIImage {
                            imgData = img.pngData()
                        }
                        
                        
                        //                        let userDefault = UserDefaults.standard
                        //                        userDefault.addSuite(named: "com.Rogue.Viewer.ShareExt")
                        //                        userDefault.set(imgData, forKey: "keynote")
                        //                        userDefault.synchronize()
                        keynoteData.append(imgData)
                        
                    })
                }
            }
            
            CKController.postKeynoteData(keynoteData, ofType: .JPG(compressionQuality: .hight), onTVsOfGroup: .all)
        }
        
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
}
