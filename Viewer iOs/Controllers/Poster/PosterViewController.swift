//
//  PosterViewController.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 27/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

class PosterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var tvGroups: [TVGroup]!
    var keynotes = [UIImage]()
    
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}
