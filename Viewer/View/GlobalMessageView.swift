//
//  GlobalMessageView.swift
//  Viewer
//
//  Created by Gianluca Orpello on 09/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit

@IBDesignable class GlobalMessageView: UIView {
    
    // TODO: - Add the correct numbers
    
    // MARK: - Frame mesure
    @IBInspectable var originalFrame = CGRect(x: 30, y: 30, width: 800, height: 495)
    @IBInspectable var secondFrame = CGRect(x: 15, y: 85, width: 390, height: 818)
    
    // MARK: - title Label mesure
    @IBInspectable var titleLabelOriginalFrame = CGRect(x: 35, y: 35, width: 750, height: 35)
    @IBInspectable var titleLabelSecondFrame = CGRect(x: 35, y: 25, width: 290, height: 35)
    
    // MARK: - subTitle Label mesure
    @IBInspectable var subTitleOriginalFrame = CGRect(x: 35, y: 35, width: 800, height: 495)
    @IBInspectable var subTitleSecondFrame = CGRect(x: 15, y: 85, width: 390, height: 818)
    
    // MARK: - Description Label mesure
    @IBInspectable var descriptionOriginalFrame = CGRect(x: 35, y: 35, width: 800, height: 495)
    @IBInspectable var descriptionSecondFrame = CGRect(x: 15, y: 85, width: 390, height: 818)
    
    // MARK: - time Label Label mesure
    @IBInspectable var timeOriginalFrame = CGRect(x: 35, y: 30, width: 800, height: 495)
    @IBInspectable var timeSecondFrame = CGRect(x: 15, y: 85, width: 390, height: 818)
    
    // MARK: - location Label mesure
    @IBInspectable var locationOriginalFrame = CGRect(x: 35, y: 30, width: 800, height: 495)
    @IBInspectable var locationSecondFrame = CGRect(x: 15, y: 85, width: 390, height: 818)
    
    // MARK: - QR Image mesure
    @IBInspectable var qrImageViewOriginalFrame = CGRect(x: 35, y: 30, width: 800, height: 495)
    @IBInspectable var qrImageViewSecondFrame = CGRect(x: 15, y: 85, width: 390, height: 818)
    
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var descriptionLabel = UILabel()
    var timeLabel = UILabel()
    var locationLabel = UILabel()
    var qrCodeImage = UIImageView()
    
    var globalMessages: [GlobalMessage] = [] {
        didSet {
            set(message: self.globalMessages.first!)
        }
    }
    
    
    @IBInspectable var havePDF: Bool = false{
        didSet{
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(timeLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(locationLabel)
        self.addSubview(qrCodeImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(timeLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(locationLabel)
        self.addSubview(qrCodeImage)
      
    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        UIView.animate(withDuration: 2) { [weak self] in
            if (self?.havePDF)!{
                self?.frame = (self?.originalFrame)!
                self?.titleLabel.frame = (self?.titleLabelOriginalFrame)!
                self?.subTitleLabel.frame = (self?.subTitleOriginalFrame)!
                self?.descriptionLabel.frame = (self?.descriptionOriginalFrame)!
                self?.timeLabel.frame = (self?.titleLabelOriginalFrame)!
                self?.locationLabel.frame = (self?.locationOriginalFrame)!
                self?.qrCodeImage.frame = (self?.qrImageViewOriginalFrame)!
            }else{
                self?.frame = (self?.secondFrame)!
                self?.titleLabel.frame = (self?.titleLabelSecondFrame)!
                self?.subTitleLabel.frame = (self?.subTitleSecondFrame)!
                self?.descriptionLabel.frame = (self?.descriptionSecondFrame)!
                self?.timeLabel.frame = (self?.timeSecondFrame)!
                self?.locationLabel.frame = (self?.locationSecondFrame)!
                self?.qrCodeImage.frame = (self?.qrImageViewSecondFrame)!
            }
        }
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            guard let colorFilter = CIFilter(name: "CIFalseColor") else { return nil }
            
            filter.setValue(data, forKey: "inputMessage")
            
            colorFilter.setValue(filter.outputImage, forKey: "inputImage")
            colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0, alpha: 0), forKey: "inputColor1") // Background clear
            colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor0") // Foreground or the barcode white
            
            if let qr = colorFilter.outputImage {
                let scaleX = qrCodeImage.frame.size.width / qr.extent.size.width
                let scaleY = qrCodeImage.frame.size.height / qr.extent.size.height
                let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
                return UIImage(ciImage: qr.transformed(by: transform))
            }
        }
        return nil
    }
    
    func set(message: GlobalMessage) {
        self.titleLabel.text = message.title
        self.descriptionLabel.text = message.description
        self.locationLabel.text = message.location
        self.qrCodeImage.image = generateQRCode(from: message.url?.absoluteString ?? "")
        self.timeLabel.text = ""
        
    }
    

}
