//
//  GlobalMessageView.swift
//  Viewer
//
//  Created by Gianluca Orpello on 09/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit
import PureLayout

@IBDesignable class GlobalMessageView: UIView {
    
    // TODO: - Add the correct numbers
    
    // MARK: - Frame mesure
    @IBInspectable var originalFrame = CGRect(x: 30, y: 30, width: 800, height: 495)
    @IBInspectable var secondFrame = CGRect(x: 30, y: 85, width: 380, height: 818)
    
    // MARK: - title Label mesure
    @IBInspectable var titleLabelOriginalFrame = CGRect(x: 41, y: 76, width: 764, height: 48)
    @IBInspectable var titleLabelSecondFrame = CGRect(x: 35, y: 160, width: 363, height: 96)
    
    // MARK: - subTitle Label mesure
    @IBInspectable var subTitleOriginalFrame = CGRect(x: 41, y: 41, width: 764, height: 36)
    @IBInspectable var subTitleSecondFrame = CGRect(x: 35, y: 110, width: 305, height: 36)
    
    // MARK: - Description Label mesure
    @IBInspectable var descriptionOriginalFrame = CGRect(x: 41, y: 150, width: 764, height: 151)
    @IBInspectable var descriptionSecondFrame = CGRect(x: 35, y: 270, width: 363, height: 214)
    
    // MARK: - time Label Label mesure
    @IBInspectable var timeOriginalFrame = CGRect(x: 215, y: 405, width: 128, height: 48)
    @IBInspectable var timeSecondFrame = CGRect(x: 44, y: 771, width: 130, height: 96)
    
    // MARK: - location Label mesure
    @IBInspectable var locationOriginalFrame = CGRect(x: 562, y: 405, width: 122, height: 48)
    @IBInspectable var locationSecondFrame = CGRect(x: 243, y: 770, width: 130, height: 96)
    
    // MARK: - QR Image mesure
    @IBInspectable var qrImageViewOriginalFrame = CGRect(x: 595, y: 405, width: 122, height: 48)
    @IBInspectable var qrImageViewSecondFrame = CGRect(x: 128, y: 509, width: 163, height: 163)
    
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
        self.addSubview(titleLabel)
        self.addSubview(timeLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(locationLabel)
        self.addSubview(qrCodeImage)
        subviews.forEach { (view) in
            view.configureForAutoLayout()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(titleLabel)
        self.addSubview(timeLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(locationLabel)
        self.addSubview(qrCodeImage)
        subviews.forEach { (view) in
            view.configureForAutoLayout()
        }
    }
    
    
    func originalLayout() {
//       View layout
        autoPinEdge(toSuperviewEdge: .top, withInset: 30)
        autoPinEdge(toSuperviewEdge: .left, withInset: 30)
        autoSetDimensions(to: CGSize(width: 800, height: 495))
        
//        Subitle Layout
        subTitleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 11)
        subTitleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 11)
        subTitleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 11)
        subTitleLabel.autoSetDimension(.height, toSize: 36)
        
//        Title Layout
        titleLabel.autoPinEdge(.left, to: .left, of: subTitleLabel)
        titleLabel.autoPinEdge(.right, to: .right, of: subTitleLabel)
        titleLabel.autoPinEdge(.top, to: .bottom, of: subTitleLabel)
        titleLabel.autoSetDimension(.height, toSize: 48)
        
//        Description Layout
        descriptionLabel.autoPinEdge(.left, to: .left, of: subTitleLabel)
        descriptionLabel.autoPinEdge(.right, to: .right, of: subTitleLabel)
        descriptionLabel.autoPinEdge(.top, to: .bottom, of: subTitleLabel,withOffset: 25)
        descriptionLabel.autoSetDimension(.height, toSize: 151)
        
        qrCodeImage.autoSetDimensions(to: CGSize(width: 164, height: 164))
        qrCodeImage.autoAlignAxis(toSuperviewAxis: .vertical)
        qrCodeImage.autoPinEdge(.top, to: .bottom, of: descriptionLabel,withOffset:15)
        
        locationLabel.autoAlignAxis(.horizontal, toSameAxisOf: qrCodeImage)
        locationLabel.autoPinEdge(.left, to: .right, of: qrCodeImage,withOffset:40)
        locationLabel.autoSetDimensions(to: CGSize(width: 113, height: 36))
        
        
        
        timeLabel.autoAlignAxis(.horizontal, toSameAxisOf: qrCodeImage)
        timeLabel.autoPinEdge(.right, to: .left, of: qrCodeImage,withOffset:40)
        timeLabel.autoSetDimensions(to: CGSize(width: 113, height: 36))
        
        
        
    }
    
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        UIView.animate(withDuration: 2) { [weak self] in
            if !(self?.havePDF)! {
               
//                self?.frame = (self?.originalFrame)!
//                self?.titleLabel.frame = (self?.titleLabelOriginalFrame)!
//                self?.subTitleLabel.frame = (self?.subTitleOriginalFrame)!
//                self?.descriptionLabel.frame = (self?.descriptionOriginalFrame)!
//                self?.timeLabel.frame = (self?.titleLabelOriginalFrame)!
//                self?.locationLabel.frame = (self?.locationOriginalFrame)!
//                self?.qrCodeImage.frame = (self?.qrImageViewOriginalFrame)!
            }else{
//                self?.frame = (self?.secondFrame)!
//                self?.titleLabel.frame = (self?.titleLabelSecondFrame)!
//                self?.subTitleLabel.frame = (self?.subTitleSecondFrame)!
//                self?.descriptionLabel.frame = (self?.descriptionSecondFrame)!
//                self?.timeLabel.frame = (self?.timeSecondFrame)!
//                self?.locationLabel.frame = (self?.locationSecondFrame)!
//                self?.qrCodeImage.frame = (self?.qrImageViewSecondFrame)!
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
        self.subTitleLabel.text = message.subtitle
        self.descriptionLabel.text = message.description
        self.locationLabel.text = message.location
        self.qrCodeImage.image = generateQRCode(from: message.url?.absoluteString ?? "www.google.com")
        self.timeLabel.text = "12:20"
        
    }
    

}
