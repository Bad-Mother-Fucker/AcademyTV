//
//  SharePosterViewController.swift
//  ShareExtension
//
//  Created by Andrea Belcore on 18/12/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit
import MobileCoreServices
import Social

class SharePosterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var tvGroups: [TVGroup]!
    var keynotes: [UIImage]! = [UIImage]()
    
    var ShareExtensionContext: NSExtensionContext?
    
    
    
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    
    override func viewDidLoad() {
        loadImagesFromAttachments()
        print(tvGroups.count, keynotes.count)
        super.viewDidLoad()
        self.ShareExtensionContext = ExtensionContextContainer.shared.context
        
        
        
        if keynotes.count != 0{
            barButtonItem.title = "Save"
            barButtonItem.action = #selector(saveKeynote)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(getPhotosFromGallery(_:)), name: NSNotification.Name("GetAllSelectedPhotos"), object: nil)
    }
    

    @IBAction func saveKeynote(_ sender: UIBarButtonItem) {
        guard keynotes.count != 0 else{
            let alert = UIAlertController(title: "Error", message: "Add at least one image", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        for group in tvGroups{
            CKController.removeKeynote(fromTVGroup: group)
            CKController.postKeynote(keynotes, ofType: ImageFileType.PNG, onTVsOfGroup: group)
        }
        
        let alert = UIAlertController(title: "Saved", message: "In a moment it will be displayed on selected tv", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        // FIXME: This completeRequest dismisses the view, i don't know whether this will work after or during the display of the alert view. It needs to be handled properly.
        self.ShareExtensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        
    }
    
    @objc func getPhotosFromGallery(_ notification: NSNotification){
        if let image = notification.userInfo?["images"] as? [UIImage] {
            keynotes = image
            self.collectionView.reloadData()
        }
    }
    
    
    @IBAction func openImagePicker(_ sender: UIBarButtonItem) {
        
        let imagePicker = self.storyboard?.instantiateViewController(withIdentifier: "ImagePickerViewController")
        self.present(imagePicker!, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keynotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryImageCell", for: indexPath) as! ImagePickerCollectionViewCell
        
        cell.imageView.image = keynotes[indexPath.item]
        cell.checkerView.isHidden = true
        
        return cell
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
                            imgData = img.jpegData(compressionQuality: 1)
                        } else if let data = item as? NSData {
                            imgData = data as Data
                        } else if let url = item as? NSURL {
                            imgData = try! Data(contentsOf: url as URL)
                        }
                        
                        
                        keynoteData.append(imgData)
                        let a = UIImage(data: imgData, scale: UIScreen.main.scale)
                        self.keynotes.append(a!)
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
                            imgData = img.pngData()
                        } else if let data = item as? NSData {
                            imgData = data as Data
                        } else if let url = item as? NSURL {
                            imgData = try! Data(contentsOf: url as URL)
                        }
                        

                        keynoteData.append(imgData)
                        let a = UIImage(data: imgData, scale: UIScreen.main.scale)
                        self.keynotes.append(a!)
                        print("\(self.keynotes.count)")
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                        
                    })
                } else {
                    print(itemProvider.registeredTypeIdentifiers.count)
                }
                
            }
            
          
            print(tvGroups.count, keynotes.count)
        } else {
            print("No content found")
        }
    }
}
