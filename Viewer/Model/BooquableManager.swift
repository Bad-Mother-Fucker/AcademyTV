//
//  BooquableManager.swift
//  Viewer
//
//  Created by Gianluca Orpello on 20/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import Foundation

enum OrderStatus: String{
    case reserved = "reserved"
    case started = "started"
    case stopped = "stopped"
}

class BooquableManager {
    
    static let shared = BooquableManager()
    
    private init(){}
    
    // MARK: - Public Api
    var orderStatus: OrderStatus = .started
    var orderId: String = ""
    var ids = [String](){
        didSet{
            print(ids)
        }
    }
    
    // MARK: - Private API Apple Developer Academy
    private var ordersWithStatusEndPoint: String {
        return "https://developer-academy.booqable.com/api/1/orders?api_key=d88efc5ef767c002befbec5a9083e562&status=\(orderStatus)"
    }
    
    private var orderEndPoint: String {
        return "https://developer-academy.booqable.com/api/1/orders/\(orderId)?api_key=d88efc5ef767c002befbec5a9083e562"
    }
    
    func getOrders(with status: OrderStatus){
                
        self.orderStatus = status
        
        getJson(from: URL(string: ordersWithStatusEndPoint)!, callBack: { json in
            DispatchQueue.main.sync {
                if let orders = json.value(forKey: "orders") as? [NSDictionary]{
                    orders.forEach { (order) in
                        self.ids.append(order.value(forKey: "id") as! String)
                    }
                }
            }
        })
    }
    
    func getOrder(from id: String) -> BooquableOrder{
        
        var booquableOrder: BooquableOrder!
        
        self.orderId = id
        
        getJson(from: URL(string: orderEndPoint)!, callBack: { json in
            DispatchQueue.main.sync {
                if let order = json.value(forKey: "order") as? NSDictionary{
                    guard let id = order.value(forKey: "id") as? String,
                        let startAt = order.value(forKey: "starts_at") as? String,
                        let stopAt = order.value(forKey: "stops_at") as? String,
                        let customer = order.value(forKey: "starts_at") as? NSDictionary,
                        let lines = order.value(forKey: "starts_at") as? NSDictionary else { return }
                    
                    booquableOrder = BooquableOrder(id: id,
                                                    startAt: startAt,
                                                    stopsAt: stopAt,
                                                    customer: customer,
                                                    lines: lines)
                }
            }
        })
        return booquableOrder
    }
    
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

