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
    
    var shareExtensionContext: NSExtensionContext?

    @IBOutlet private weak var barButtonItem: UIBarButtonItem!
    
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    
    override func viewDidLoad() {
        loadImagesFromAttachments()
        print(tvGroups.count, keynotes.count)
        super.viewDidLoad()
        self.shareExtensionContext = ExtensionContextContainer.shared.context
        
        
        
        if keynotes.count != 0 {
            barButtonItem.title = "Save"
            barButtonItem.action = #selector(saveKeynote)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(getPhotosFromGallery(_:)), name: NSNotification.Name("GetAllSelectedPhotos"), object: nil)
    }
    

    @IBAction private func saveKeynote(_ sender: UIBarButtonItem) {
        guard keynotes.count != 0 else {
            let alert = UIAlertController(title: "Error", message: "Add at least one image", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        for group in tvGroups {
            CKController.removeKeynote(fromTVGroup: group)
            CKController.postKeynote(keynotes, ofType: ImageFileType.PNG, onTVsOfGroup: group)
        }
        
        self.shareExtensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        
    }
    
    @objc func getPhotosFromGallery(_ notification: NSNotification) {
        if let image = notification.userInfo?["images"] as? [UIImage] {
            keynotes = image
            self.collectionView.reloadData()
        }
    }
    
    
    @IBAction private func openImagePicker(_ sender: UIBarButtonItem) {
        
        let imagePicker = self.storyboard?.instantiateViewController(withIdentifier: "ImagePickerViewController")
        self.present(imagePicker!, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keynotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryImageCell", for: indexPath) as? ImagePickerCollectionViewCell {
            cell.currentImage = keynotes[indexPath.item]
            cell.isCheked = true

            return cell
        } else { return UICollectionViewCell() }
    }
    
    func loadImagesFromAttachments() {
        
        let UTI = kUTTypeImage as String
        
        var keynoteData: [Data] = []
        
        if let content = self.shareExtensionContext?.inputItems[0] as? NSExtensionItem {
            print("Found \(String(describing: content.attachments?.count)) attachments")
            for element in content.attachments! {
                let itemProvider = element
                if itemProvider.hasItemConformingToTypeIdentifier(UTI) {
                    itemProvider.loadItem(forTypeIdentifier: UTI, options: nil, completionHandler: { (item, error) in
                        
                        if error != nil {
                            print("there was an error", error!.localizedDescription)
                        }
                        
                        var imgData: Data!
//                        var img: UIImage?

                        if let img = item as? UIImage {
                            imgData = img.byFixingOrientation().jpegData(compressionQuality: 1)
                        } else if let data = item as? NSData {
                            imgData = data as Data
                        } else if let url = item as? NSURL {
                            do {
                                imgData = try Data(contentsOf: url as URL)
                            } catch {
                                NSLog("Can't get imgData - SharePosterViewController: loadImagesFromAttachments")
                            }
                        }
                        
                        keynoteData.append(imgData)
                        let a = UIImage(data: imgData, scale: UIScreen.main.scale)
                        self.keynotes.append(a!)
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    })
                } else if itemProvider.hasItemConformingToTypeIdentifier("public.png") {
                   
                    itemProvider.loadItem(forTypeIdentifier: "public.png", options: nil, completionHandler: { (item, error) in
                        
                        if error != nil {
                            print("there was an error", error!.localizedDescription)
                        }
                        
                        var imgData: Data!
                        
                        if let img = item as? UIImage {
                            imgData = img.byFixingOrientation().pngData()
                        } else if let data = item as? NSData {
                            imgData = data as Data
                        } else if let url = item as? NSURL {
                            do {
                                imgData = try Data(contentsOf: url as URL)
                            } catch {
                                NSLog("Error get the imgData - SharePosterViewController: loadImagesFromAttachments")
                            }
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

extension UIImage {
    
    func byFixingOrientation(andResizingImageToNewSize newSize: CGSize? = nil) -> UIImage {
        
        guard let cgImage = self.cgImage else { return self }
        
        let orientation = self.imageOrientation
        guard orientation != .up else { return UIImage(cgImage: cgImage, scale: 1, orientation: .up) }
        
        var transform = CGAffineTransform.identity
        let size = newSize ?? self.size
        
        if orientation == .down || orientation == .downMirrored {
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
        } else if orientation == .left || orientation == .leftMirrored {
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)
        } else if orientation == .right || orientation == .rightMirrored {
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -(CGFloat.pi / 2))
        }
        
        if orientation == .upMirrored || orientation == .downMirrored {
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        } else if orientation == .leftMirrored || orientation == .rightMirrored {
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform calculated above.
        guard let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
                                  bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0,
                                  space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue)
            else {
                return UIImage(cgImage: cgImage, scale: 1, orientation: orientation)
        }
        
        ctx.concatenate(transform)
        
        // Create a new UIImage from the drawing context
        switch orientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        return UIImage(cgImage: ctx.makeImage() ?? cgImage, scale: 1, orientation: .up)
    }
}
