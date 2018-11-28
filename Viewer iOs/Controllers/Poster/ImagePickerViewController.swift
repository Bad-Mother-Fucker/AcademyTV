//
//  ImagePickerViewController.swift
//  Viewer iOs
//
//  Created by Gianluca Orpello on 27/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit
import Photos

class ImagePickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var allPhotos = PHFetchResult<PHAsset>()
    var selectedPhoto = [UIImage]()
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.allowsMultipleSelection = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let allPhotoOption = PHFetchOptions()
        allPhotoOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        allPhotos = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: allPhotoOption)
        
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 1920, height: 1080), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    @IBAction func saveImages(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: NSNotification.Name("GetAllSelectedPhotos"), object: nil, userInfo: ["images": selectedPhoto])
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgeCollectionViewCell", for: indexPath) as! ImagePickerCollectionViewCell
        
        cell.imageView.image = getAssetThumbnail(asset: allPhotos[indexPath.item])
        cell.isSelected = false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.isSelected = true
        selectedPhoto.append(getAssetThumbnail(asset: allPhotos[indexPath.item]))
    }

}
