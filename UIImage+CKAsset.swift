//
//  UIImage+CKAsset.swift
//
//
//  Created by Michele De Sena on 10/9/18.
//
//
import UIKit
import CloudKit

enum ImageFileType {
    case JPG(compressionQuality: Quality)
    case PNG
    
    var fileExtension: String {
        switch self {
        case .JPG:
            return ".jpg"
        case .PNG:
            return ".png"
        }
    }
}


enum Quality: CGFloat {
    // FIXME: "Hight" should be "high"
    case hight = 0.8
    case medium = 0.5
    case low = 0.3
    
}

enum ImageError: Error {
    case unableToConvertImageToData
}

extension CKAsset {
    convenience init(image: UIImage, fileType: ImageFileType) throws {
        let url = try image.saveToTempLocationWithFileType(fileType)
        self.init(fileURL: url)
    }
    
    convenience init(fromData data: Data, ofType fileType: ImageFileType) throws {
        let url = try data.saveToTempLocationWithFileType(fileType)
        self.init(fileURL: url)
    }
    
    var image: UIImage? {
        guard let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) else { return nil }
        return image
    }
}

extension UIImage {
    func saveToTempLocationWithFileType(_ fileType: ImageFileType) throws -> URL {
        let imageData: Data?
        
        switch fileType {
        case .JPG(let quality):
            imageData = self.jpegData(compressionQuality: quality.rawValue)
        case .PNG:
            imageData = self.pngData()
        }
        guard let data = imageData else {
            throw ImageError.unableToConvertImageToData
        }
        
        let filename = ProcessInfo.processInfo.globallyUniqueString + fileType.fileExtension
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
        try data.write(to: url, options: .atomicWrite)
        return url
    }
}


extension Data {
    func saveToTempLocationWithFileType(_ fileType: ImageFileType) throws -> URL {
        let filename = ProcessInfo.processInfo.globallyUniqueString + fileType.fileExtension
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
        try self.write(to: url, options: .atomicWrite)
        return url
    }
}

