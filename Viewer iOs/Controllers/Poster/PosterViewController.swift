//
//  PosterViewController.swift
//  Viewer
//
//  Created by Gianluca Orpello on 14/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit
import Photos

class PosterViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = false
        
        tableView.tableFooterView = UIView()
        
        let userDefault = UserDefaults.standard
        userDefault.addSuite(named: "com.Rogue.Viewer.ShareExt")
        
        if let dict = userDefault.value(forKey: "keynote") as? [String:Any]{
            
            let data = dict["imgData"] as! [Data]
            let str = dict["name"] as! String
            print(data,str)
            userDefault.removeObject(forKey: "img")
            userDefault.synchronize()
            
        }
        
    }
    
    @IBOutlet weak var imageViewController: UIImageView!{
        didSet{
            imageViewController.layer.borderWidth = 2
            imageViewController.layer.borderColor = UIColor.blue.cgColor
            imageViewController.layer.cornerRadius = 20
            imageViewController.clipsToBounds = true
        }
    }
    
    @IBAction func getImageFromGallery(_ sender: UIButton) {
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                debugPrint("Button capture")
                
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                debugPrint("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    
                    if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                        debugPrint("Button capture")
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }
                    debugPrint("success")
                }
            })
            debugPrint("It is not determined until now")
        default:
            break
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage{
            imageViewController.image = pickedImage
        }
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "postGlobalMessageSegue":
            break
        case "postImageSegue":
            
            guard imageViewController.image != nil else {
                
                let alert = UIAlertController(title: "Select Image", message: "You have to select an image to share.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
                
                return
            }
            
            if segue.identifier == "ChooseLocationSegue"{
                if let destination = segue.destination as? TvListViewController{
                    destination.image = imageViewController.image!
                }
            }
            
        default:
            break
        }
    }
    
}
