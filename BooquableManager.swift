//
//  BooquableManager.swift
//  Viewer
//
//  Created by Gianluca Orpello on 20/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import Foundation

/**
 ## Enumeration of the possible order status
 
 - Version: 1.0
 
 - Author: @GianlucaOrpello
 */
enum OrderStatus: String{
    case reserved = "reserved"
    case started = "started"
    case stopped = "stopped"
}

/**
 ## Manager class for Booquable
 
 - SeeAlso: For more info see the [Booquable Documentation](https://booqable.com/blog/booqable-api-documentation/)
 
 - Version: 1.0
 
 - Author: @GianlucaOrpello
 */
class BooquableManager {
    
    // MARK: - Shared instance
    static let shared = BooquableManager()
    
    // MARK: - Private init
    private init(){}
    
    // MARK: - Public Api
    var orderStatus: OrderStatus = .started
    var orderId: String = ""
    var ids = [String]()
    
    // MARK: - Private API related to Apple Developer Academy
    private var ordersWithStatusEndPoint: String {
        return "https://developer-academy.booqable.com/api/1/orders?api_key=d88efc5ef767c002befbec5a9083e562&status=\(orderStatus)"
    }
    
    private var orderEndPoint: String {
        return "https://developer-academy.booqable.com/api/1/orders/\(orderId)?api_key=d88efc5ef767c002befbec5a9083e562"
    }
    
    // MARK: - Public function
    
    /**
     ## Collect the orders with a specific status.
     
     When this function is called a urs session is started. The end point is the booquable webservice.
     This function are called in asynchronous way, at the end they return all the orders from booquable.
     
     - Parameters:
        - status: The stus of the orders. According to Booquable API, you can query the orders based on the current status
    
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func getOrders(with status: OrderStatus){
                
        self.orderStatus = status
        
        getJson(from: URL(string: ordersWithStatusEndPoint)!, callBack: { json in
            DispatchQueue.main.sync {
                if let orders = json.value(forKey: "orders") as? [NSDictionary]{
                    orders.forEach { (order) in
                        self.ids.append((order.value(forKey: "id") as? String)!)
                    }
                    NotificationCenter.default.post(name: NSNotification.Name("GetAllOrders"), object: nil)
                }
            }
        })
    }
    
    /**
     ## Get a specific order from the order list
     
     With this function is possible to extract the data of a specific order inside the order list.
     You can call it with a specific order ID. When a order is extract, a notification with the key "NewOrder" are posted.
     
     - Parameters:
        - id: The ID of the specific order
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    func getOrder(from id: String){
        
        self.orderId = id
        getJson(from: URL(string: orderEndPoint)!, callBack: { json in
            DispatchQueue.main.sync {
                if let order = json.value(forKey: "order") as? NSDictionary{
                    guard let id = order.value(forKey: "id") as? String,
                        let startAt = order.value(forKey: "starts_at") as? NSString,
                        let stopAt = order.value(forKey: "stops_at") as? NSString,
                        let customer = order.value(forKey: "customer") as? NSDictionary,
                        let lines = order.value(forKey: "lines") as? NSArray else {
                            debugPrint("Can't cast")
                            return
                    }
                    
                    let booquableOrder = BooquableOrder(id: id,
                                                        startAt: startAt as String,
                                                        stopsAt: stopAt as String,
                                                    customer: customer,
                                                    lines: (lines[0] as? NSDictionary)!)
                    
                    NotificationCenter.default.post(name: NSNotification.Name("NewOrder"), object: nil, userInfo: ["order": booquableOrder])
                }
            }
        })
    }
    
    /**
     ## Get a json from a specific URL
     
     When this function is called a urs session is started. The session point to the specific endpoint passed inside the argument.
     This function are called in asynchronous way, at the end they return the json.
     
     - Parameters:
        - url: The endpoint of the json.
        - callBack: A function to execute when the json is downloaded.
     
     - Todo: Check if the session need to be closed,
     
     - Version: 1.0
     
     - Author: @GianlucaOrpello
     */
    private func getJson(from url: URL, callBack: @escaping (NSDictionary) -> ()){
        
        //fetching the data from the url
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
            guard error == nil, let data = data else {
                print(error!.localizedDescription)
                return
            }
            
            let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            if let json = jsonObj as? NSDictionary {
                callBack(json)
            }
        })
        task.resume()
    }
}

