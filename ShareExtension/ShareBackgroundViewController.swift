//
//  ShareBackgroundViewController.swift
//  ShareExtension
//
//  Created by Andrea Belcore on 18/12/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

class ExtensionContextContainer {
    var context: NSExtensionContext?
    
    static let shared = ExtensionContextContainer()
    
}

class ShareBackgroundViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let content = self.extensionContext?.inputItems[0] as? NSExtensionItem {
            ExtensionContextContainer.shared.context = self.extensionContext
            debugPrint(content.attachments?.count ?? -1)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.performSegue(withIdentifier: "Show", sender: self)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
