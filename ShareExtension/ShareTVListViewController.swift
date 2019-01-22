//
//  ShareViewController.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 10/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit
import MobileCoreServices
import Social

class ShareTvListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPopoverPresentationControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: Class variables
    
    var groups = globalGroups
    
    var selectedGroup: TVGroups?
    var selectedGroups: [TVGroup]?
    var keynote: [UIImage] = [UIImage]()
    var category: Categories?
    var tickerMessage: String?
    
    var ShareExtensionContext: NSExtensionContext?
    
    @IBAction func cancelShare(_ sender: Any) {
        self.ShareExtensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    // MARK: CollectionView methods
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.allowsMultipleSelection = true
            
        }
    }
    // MARK: NextBarButton
    @IBOutlet weak var postBarButtonItem: UIBarButtonItem!
    
    @IBAction func postBarButtonPressed(_ sender: Any) {
//        let summary = SummaryViewController()
//        summary.isCheckoutMode = true
//        summary.categories = category
//
//        if let cat = category{
//
//            switch cat{
//            case Categories.TickerMessage:
//
//                var tvNames: String = ""
//                for group in selectedGroups!{
//                    tvNames.append(group.rawValue)
//                    tvNames.append(", ")
//                }
//                let prop = (message: tickerMessage, tvName: tvNames, TVGroup:selectedGroups)
//                summary.prop = prop
//
//                break
//
//            case Categories.KeynoteViewer:
//
//                var tvNames: String? = ""
//                for group in selectedGroups!{
//                    tvNames!.append(contentsOf: group.rawValue)
//                }
//                let prop = (image: keynote, tvName: tvNames, TVGroup: selectedGroups)
//                summary.prop = prop
//
//                break
//            default:
//                break
//            }
//
//        }
//
//        navigationController?.pushViewController(summary, animated: true)
        shareContent(self)
        
    }
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ShareExtensionContext = ExtensionContextContainer.shared.context
        loadImagesFromAttachments()
        
        
        selectedGroups = []
        postBarButtonItem.isEnabled = false
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(getPhotosFromGallery(_:)), name: NSNotification.Name("GetAllSelectedPhotos"), object: nil)
        
        
    }
    
    @objc func getPhotosFromGallery(_ notification: NSNotification){
        if let images = notification.userInfo?["images"] as? [UIImage] {
            keynote = images
            self.collectionView.reloadData()
        }
    }
    
    // MARK: DelegateFlowLayout methods
    // setting correct spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if (UIScreen.main.bounds.width < 414){
            return UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        } else {
            return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if (UIScreen.main.bounds.width < 414){
            return 43
        } else {
            return 28
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat
        let height : CGFloat
        
        //iPhone 8, X, Xs
        if (UIScreen.main.bounds.width < 414){
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
            if (UIScreen.main.bounds.width < 414){
                borderCell.frame.size = CGSize(width: 335, height: 45)
            } else {
                borderCell.frame.size = CGSize(width: 384, height: 45)
            }
            
            borderCell.titleLabel.text = "Select All"
            return borderCell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        if cell?.reuseIdentifier == "TVGroup"{
            cell!.isSelected = true
            selectedGroups!.append(groups[indexPath.item - 1].name)
        }else{
            for i in 1..<collectionView.numberOfItems(inSection: 0){
                collectionView.selectItem(at: IndexPath(item: i, section: 0), animated: true, scrollPosition: .bottom)
            }
            selectedGroups!.removeAll()
            for group in groups {
                
                selectedGroups!.append(group.name)
            }
            
            
        }
        
        if selectedGroups!.isEmpty {
            postBarButtonItem.isEnabled = false
        } else {
            postBarButtonItem.isEnabled = true
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        if cell?.reuseIdentifier == "TVGroup"{
            cell!.isSelected = false
            selectedGroups = selectedGroups!.filter { (tvGroup) -> Bool in
                if tvGroup == groups[indexPath.item - 1].name{
                    return false
                }else{
                    return true
                }
            }
        }else{
            for i in 1..<collectionView.numberOfItems(inSection: 0){
                collectionView.deselectItem(at: IndexPath(item: i, section: 0), animated: true)
            }
            selectedGroups!.removeAll()
        }
        if selectedGroups!.isEmpty {
            postBarButtonItem.isEnabled = false
        } else {
            postBarButtonItem.isEnabled = true
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
    
    func shareContent(_ sender: Any) {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        
        guard keynote.count != 0 else{
            let alert = UIAlertController(title: "Error", message: "Add at least one image", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        for group in groups{
            CKController.removeKeynote(fromTVGroup: group.name)
            CKController.postKeynote(keynote, ofType: ImageFileType.PNG, onTVsOfGroup: group.name)
        }
        
        let alert = UIAlertController(title: "Saved", message: "In a moment it will be displayed on selected tv", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        // FIXME: This completeRequest dismisses the view, i don't know whether this will work after or during the display of the alert view. It needs to be handled properly.
        self.ShareExtensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    func loadImagesFromAttachments(){
        
        let UTI = kUTTypeImage as String
        
        var keynoteData: [Data] = []
        
        if let content = self.ShareExtensionContext?.inputItems[0] as? NSExtensionItem{
            print("Found \(content.attachments?.count) attachments")
            for element in content.attachments!{
                let itemProvider = element
                itemProvider
                if itemProvider.hasItemConformingToTypeIdentifier(UTI){
                    itemProvider.loadItem(forTypeIdentifier: UTI, options: nil, completionHandler: { (item, error) in
                        
                        if let _ = error {
                            
                            print("there was an error",error!.localizedDescription)
                        }
                        
                        var imgData: Data!
                        var img: UIImage?
                        
                        
                        
                        if let img = item as? UIImage {
                            imgData = img.byFixingOrientation().jpegData(compressionQuality: 1)
                        } else if let data = item as? NSData {
                            imgData = data as Data
                        } else if let url = item as? NSURL {
                            imgData = try! Data(contentsOf: url as URL)
                        }
                        
                        
                        keynoteData.append(imgData)
                        let a = UIImage(data: imgData, scale: UIScreen.main.scale)
                        self.keynote.append(a!)
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    })
                }else if itemProvider.hasItemConformingToTypeIdentifier("public.png"){
                    
                    itemProvider.loadItem(forTypeIdentifier: "public.png", options: nil, completionHandler: { (item, error) in
                        
                        if let _ = error {
                            print("there was an error",error!.localizedDescription)
                        }
                        
                        var imgData: Data!
                        
                        if let img = item as? UIImage {
                            imgData = img.byFixingOrientation().pngData()
                        } else if let data = item as? NSData {
                            imgData = data as Data
                        } else if let url = item as? NSURL {
                            imgData = try! Data(contentsOf: url as URL)
                        }
                        
                        
                        keynoteData.append(imgData)
                        let a = UIImage(data: imgData, scale: UIScreen.main.scale)
                        self.keynote.append(a!)
                        print("\(self.keynote.count)")
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                        
                    })
                } else {
                    print(itemProvider.registeredTypeIdentifiers.count)
                }
                
            }
            
            
        } else {
            print("No content found")
        }
    }

}

