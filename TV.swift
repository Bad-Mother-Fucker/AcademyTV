//
//  File.swift
//  Viewer
//
//  Created by Gianluca Orpello on 21/10/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import Foundation
import UIKit
import CloudKit


class TVModel {
    static func addTV(withName name: String, completionHandler: @escaping (CKRecord?,Error?)-> Void){
        let tv = TV(name:name)
        CKKeys.database.save(tv.record) {
            (record, error) in
            if let /*error*/_ = error {
                // Insert error handling
                print(error!.localizedDescription)
                return
            }
            //successfully saved record code
            completionHandler(record,error)
            print("TV Saved")
        }
    }
    
    static func doesExist(completionHandler: @escaping (Bool,Error?)->Void) {
        let predicate = NSPredicate(format: "recordName == %@", UIDevice.current.identifierForVendor!.uuidString)
        let query = CKQuery(recordType: TV.recordType, predicate: predicate)
        
        CKKeys.database.perform(query, inZoneWith: nil) { (records, error) in
            guard error == nil,let _ = records else {
                completionHandler(false,error!)
                return
            }
            guard records!.count > 0 else {
                completionHandler(false,nil)
                return
            }
            completionHandler(true,nil)
            
        }
    }
    
    static func getTV(withName name:String,completionHandler: @escaping (TV?,Error?)->Void) {
        let predicate = NSPredicate(format: "\(TV.keys.name) == %@", name)
        print("fetching with name \(name)")
        let query = CKQuery(recordType: TV.recordType, predicate: predicate)
        
        CKKeys.database.perform(query, inZoneWith: nil) { (records, error) in
            guard let _ = records, error == nil else {
//                error handling
                completionHandler(nil,error)
                return
            }
            guard records!.count > 0 else {
                completionHandler(nil,CKQueryException.recordNotFound("No TV Found in pulic databse with the given name"))
                return
            }
            
            let tv = TV(record: records!.first!)
            completionHandler(tv,error)

        }

    }
    
    
    static func getTvs(ofGroup group: TVGroup,completionHandler: @escaping ([TV]?,Error?)->Void){
        let predicate = group == .all ? NSPredicate(value: true) : NSPredicate(format: "\(TV.keys.tvGroup) == %@", group.rawValue)
        let query = CKQuery(recordType: TV.recordType, predicate: predicate)
        
        CKKeys.database.perform(query, inZoneWith: nil) { (records, error) in
            guard let _ = records, error == nil else {
                //  error handling
                completionHandler(nil,error)
                return
            }
            
            guard records!.count > 0 else {
                completionHandler(nil,CKQueryException.recordNotFound("No TV Found in pulic databse with the given name"))
                return
            }
            
            let tvs = records!.map({ (record) -> TV in
                return TV(record: record)
            })
            completionHandler(tvs,nil)
        }
    }
    
    
}

class TV: CloudStored {
    var record: CKRecord
    
    static var recordType: String = "TVs"
    static var keys = (name: "name", uuid: "recordName", tvGroup: "tvGroup",isOn:"isOn",keynote:"keynote")
    
    required init(record: CKRecord) {
        self.record = record
    }
    
    var keynoteDelegate: ATVKeynoteViewDelegate?
    var hasKeynote: Bool = false
    
    init (name: String) {
        self.record = CKRecord(recordType: TV.recordType)
        record.setValue(name , forKey: TV.keys.name)
        record.setValue(1, forKey: TV.keys.isOn)
        let group: TVGroup
        switch name {
        case "kitchen":
            group = .kitchen
        case "seminar":
            group = .seminar
        default:
            group = TVGroup(rawValue: String(name.dropLast(3))) ?? .all
        }
        record.setValue(group.rawValue, forKey: TV.keys.tvGroup)
        record.setValue(UIDevice.current.identifierForVendor!.uuidString, forKey: TV.keys.uuid)
    }
    
    var keynote:[UIImage]? {
        if let assets = record.value(forKey: TV.keys.keynote) as? [CKAsset] {
            let images: [UIImage] = assets.map { (asset) -> UIImage in
                guard let image = asset.image else {return UIImage()} //Returns a white background image if it was not possible to decode single image data
                return image
            }
            return images
        }else {
            return nil
        }
    }
    
    
    var isOn: Bool {
        get{
            return record.value(forKey: TV.keys.isOn) as! Int  == 0 ? false : true
        }
        set {
            newValue ? record.setValue(1, forKey: TV.keys.isOn) : record.setValue(0, forKey: TV.keys.isOn)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    var name: String {
        get{
            return record.value(forKey: TV.keys.name) as! String
        }
        set{
            record.setValue(newValue, forKey: TV.keys.name)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    var uuid: String  {
        get{
            return record.value(forKey: TV.keys.uuid) as! String
        }
        set{
            record.setValue(newValue, forKey: TV.keys.uuid)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
    
    var tvGroup: TVGroup {
        get {
            return TVGroup(rawValue: record.value(forKey: TV.keys.tvGroup) as! String) ?? .all
        }
        set{
            record.setValue(newValue.rawValue, forKey: TV.keys.tvGroup)
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.savePolicy = .changedKeys
            CKKeys.database.add(op)
        }
    }
   
    
    func set(keynote: [UIImage], imageType: ImageFileType) {
        
        var assets: [CKAsset] = []
        
        for page in keynote {
            do {
                let asset = try CKAsset(image: page, fileType: imageType)
                assets.append(asset)
            }
            catch {
                print("Error creating assets", error)
            }
        }
        self.record.setValue(assets,forKey:TV.keys.keynote)
        let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        op.savePolicy = .changedKeys
        CKKeys.database.add(op)
    }
    
    func setKeynoteData(_ keynote:[Data],ofType imageType: ImageFileType) {
        var assets: [CKAsset] = []
        
        for page in keynote {
            do {
                let asset = try CKAsset(fromData: page, ofType: imageType)
                assets.append(asset)
            }
            catch {
                print("Error creating assets", error)
            }
        }
        self.record.setValue(assets,forKey:TV.keys.keynote)
        let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        op.savePolicy = .changedKeys
        CKKeys.database.add(op)
    }
    
    func removeKeynote() {
        self.record.setValue(nil, forKey: TV.keys.keynote)
        let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        op.savePolicy = .changedKeys
        CKKeys.database.add(op)
    }
    
}
