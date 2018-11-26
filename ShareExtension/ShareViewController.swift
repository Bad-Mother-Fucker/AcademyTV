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


class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        
        let UTI = kUTTypeImage as String
        if let item = self.extensionContext?.inputItems[0] as? NSExtensionItem{
            var keynoteData: [Data] = []
            for element in item.attachments!{
                let itemProvider = element 
                
                if itemProvider.hasItemConformingToTypeIdentifier(UTI){
                
//                    NSLog("itemprovider: %@", itemProvider)
                    itemProvider.loadItem(forTypeIdentifier: UTI, options: nil, completionHandler: { (item, error) in
                        
                        if let _ = error {
                            
                            print("there was an error",error!.localizedDescription)
                        }
                        
                        var imgData: Data!
                        if let url = item as? URL {
                           imgData = try! Data(contentsOf: url)
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
                }else if itemProvider.hasItemConformingToTypeIdentifier("public.png"){
//                    NSLog("itemprovider: %@", itemProvider)
                    itemProvider.loadItem(forTypeIdentifier: "public.png", options: nil, completionHandler: { (item, error) in
                        
                        if let _ = error {
                            print("there was an error",error!.localizedDescription)
                        }

                        
                        
                        var imgData: Data!
                        if let url = item as? URL {
                            imgData = try! Data(contentsOf: url)
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

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
