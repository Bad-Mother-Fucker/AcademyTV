//
//  GlassOfficeViewController.swift
//  Viewer
//
//  Created by Gianluca Orpello on 16/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

class GlassOfficeViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!{
        didSet{
            setDate()
            Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] (timer) in
                self?.setDate()
            }
        }
    }
    
    // MARK: - API Apple Developer Academy
    var APIkey = "d88efc5ef767c002befbec5a9083e562"
    var key: String{
        return "?api_key=\(APIkey)"
    }
    var endpoint = "https://developer-academy.booqable.com/api/1/"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let url = URL(string: endpoint+"orders"+key)
        var request = URLRequest(url:url!)
        request.httpMethod = "GET"
        
        getJson(from: url!)
        
    }
    
    private func setDate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, HH:mm"
        
        self.dateLabel.text = dateFormatter.string(from: date)
    }
    
    //this function is fetching the json from URL
    private func getJson(from url: URL){
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                //printing the json in console
                print("Json: ")
                print(jsonObj ?? "nil")
                
//                //getting the avengers tag array from json and converting it to NSArray
//                if let heroeArray = jsonObj!.value(forKey: "avengers") as? NSArray {
//                    //looping through all the elements
//                    for heroe in heroeArray{
//
//                        //converting the element to a dictionary
//                        if let heroeDict = heroe as? NSDictionary {
//
//                            //getting the name from the dictionary
//                            if let name = heroeDict.value(forKey: "name") {
//
//                                //adding the name to the array
//                                self.nameArray.append((name as? String)!)
//                            }
//
//                        }
//                    }
//                }
//
//                OperationQueue.main.addOperation({
//                    //calling another function after fetching the json
//                    //it will show the names to label
//                    self.showNames()
//                })
            }
        }).resume()
    }
}
