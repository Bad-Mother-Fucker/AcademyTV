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
    var descriptionLabel = UITextView()
    var timeLabel = UILabel()
    var locationLabel = UILabel()
    var dateLabel = UILabel()
    var whenLabel = UILabel()
    var whereLabel = UILabel()
    
    
    
    var qrCodeImage = UIImageView()
    
    var globalMessages: [GlobalMessage] = [] {
        didSet {
            if globalMessages.count > 0 {
                switchMessages()
            }
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
        self.addSubview(dateLabel)
        self.addSubview(whenLabel)
        self.addSubview(whereLabel)
        
        whenLabel.text = "When"
        whereLabel.text = "Where"
        subviews.forEach { (view) in
            view.configureForAutoLayout()
        }
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        titleLabel.font = UIFont.systemFont(ofSize: 57, weight: .medium)
        titleLabel.textColor = .white
        subTitleLabel.font = UIFont.systemFont(ofSize: 29)
        subTitleLabel.textColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 29)
        descriptionLabel.textColor = .white
        timeLabel.font = UIFont.systemFont(ofSize: 23)
        timeLabel.textColor = .white
        dateLabel.font = UIFont.systemFont(ofSize: 23)
        dateLabel.textColor = .white
        locationLabel.font = UIFont.systemFont(ofSize: 23)
        locationLabel.textColor = .white
        whenLabel.font = UIFont.systemFont(ofSize: 40,weight: .medium)
        whenLabel.textColor = .white
        whereLabel.font = UIFont.systemFont(ofSize: 40,weight: .medium)
        whereLabel.textColor = .white
        
        timeLabel.textAlignment = .center
        dateLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        locationLabel.numberOfLines = 0
        locationLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 0
        
        descriptionLabel.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        
        self.addSubview(titleLabel)
        self.addSubview(timeLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(locationLabel)
        self.addSubview(qrCodeImage)
        self.addSubview(dateLabel)
        self.addSubview(whenLabel)
        self.addSubview(whereLabel)
       
        subviews.forEach { (view) in
            view.configureForAutoLayout()
        }
        
       
    }
    
    
    private func originalLayout() {
        autoPinEdgesToSuperviewEdges()
        
        //        Subitle Layout
        subTitleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        subTitleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
        subTitleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
        subTitleLabel.autoSetDimension(.height, toSize: 46)
        
        //        Title Layout
        titleLabel.autoPinEdge(.left, to: .left, of: subTitleLabel)
        titleLabel.autoPinEdge(.right, to: .right, of: subTitleLabel)
        titleLabel.autoPinEdge(.top, to: .bottom, of: subTitleLabel)
        titleLabel.autoSetDimension(.height, toSize: 68)
        
        //        Description Layout
        descriptionLabel.autoPinEdge(.left, to: .left, of: subTitleLabel)
        descriptionLabel.autoPinEdge(.right, to: .right, of: subTitleLabel)
        descriptionLabel.autoPinEdge(.top, to: .bottom, of: titleLabel,withOffset: 8)
        descriptionLabel.autoSetDimension(.height, toSize: 151)
        
//        Bottom Labels layout
        
        whenLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 200)
        whenLabel.autoSetDimensions(to: CGSize(width: 113, height: 46))
        whenLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 195)
        
        dateLabel.autoPinEdge(.top, to: .bottom, of: whenLabel,withOffset: 8)
        dateLabel.autoPinEdge(.left, to: .left, of: whenLabel)
        dateLabel.autoPinEdge(.right, to: .right, of: whenLabel)
        dateLabel.autoSetDimension(.height, toSize: 60)
        
        timeLabel.autoPinEdge(.top, to: .bottom, of: dateLabel,withOffset: 8)
        timeLabel.autoPinEdge(.left, to: .left, of: whenLabel)
        timeLabel.autoPinEdge(.right, to: .right, of: whenLabel)
        timeLabel.autoSetDimension(.height, toSize: 60)
        
        qrCodeImage.autoSetDimensions(to: CGSize(width: 194, height: 194))
        qrCodeImage.autoPinEdge(toSuperviewEdge: .bottom, withInset: 70)
        qrCodeImage.autoPinEdge(.left, to: .right, of: timeLabel,withOffset: 25)
        
        whereLabel.autoPinEdge(.left, to: .right, of: qrCodeImage, withOffset: 25)
        whereLabel.autoSetDimensions(to: CGSize(width: 123, height: 36))
        whereLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 195)
        
        locationLabel.autoPinEdge(.left, to: .left, of: whereLabel)
        locationLabel.autoSetDimension(.width, toSize: 123)
        locationLabel.autoPinEdge(.top, to: .bottom, of: whereLabel,withOffset: 8)
        
    }
    
    
    
    private func keynoteLayout() {
        
        //        View Layout
        autoPinEdgesToSuperviewEdges()
                
        //        Subitle Layout
        subTitleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 15)
        subTitleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        subTitleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        subTitleLabel.autoSetDimension(.height, toSize: 36)
        
        //        Title Layout
        titleLabel.autoPinEdge(.left, to: .left, of: subTitleLabel)
        titleLabel.autoPinEdge(.right, to: .right, of: subTitleLabel)
        titleLabel.autoPinEdge(.top, to: .bottom, of: subTitleLabel)
        
        
        //        Description Layout
        descriptionLabel.autoPinEdge(.left, to: .left, of: subTitleLabel)
        descriptionLabel.autoPinEdge(.right, to: .right, of: subTitleLabel)
        descriptionLabel.autoPinEdge(.top, to: .bottom, of: titleLabel,withOffset: 25)
        descriptionLabel.autoSetDimension(.height, toSize: 102)
        
        
        
        qrCodeImage.autoSetDimensions(to: CGSize(width: 194, height: 194))
        qrCodeImage.autoAlignAxis(.vertical, toSameAxisOf: descriptionLabel)
        qrCodeImage.autoPinEdge(.top, to: .bottom, of: descriptionLabel,withOffset: 8)
        
        
        
        whenLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 60)
        whenLabel.autoSetDimensions(to: CGSize(width: 113, height: 46))
        whenLabel.autoPinEdge(.top, to: .bottom, of: qrCodeImage,withOffset:45)
        
        
        whereLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 60)
        whereLabel.autoSetDimensions(to: CGSize(width: 123, height: 46))
        whereLabel.autoPinEdge(.top, to: .bottom, of: qrCodeImage,withOffset:45)
        
        
        dateLabel.autoPinEdge(.top, to: .bottom, of: whenLabel,withOffset: 8)
        dateLabel.autoPinEdge(.left, to: .left, of: whenLabel)
        dateLabel.autoPinEdge(.right, to: .right, of: whenLabel)
        dateLabel.autoSetDimension(.height, toSize: 60)
        
        timeLabel.autoPinEdge(.top, to: .bottom, of: dateLabel,withOffset: 8)
        timeLabel.autoPinEdge(.left, to: .left, of: whenLabel)
        timeLabel.autoPinEdge(.right, to: .right, of: whenLabel)
        timeLabel.autoSetDimension(.height, toSize: 60)
        
        locationLabel.autoPinEdge(.left, to: .left, of: whereLabel)
        locationLabel.autoPinEdge(.right, to: .right, of: whereLabel)
        locationLabel.autoPinEdge(.top, to: .bottom, of: whereLabel,withOffset: 8)
        
    }
    
    
    func setLayout(type: TVLayoutType) {
        UIView.animate(withDuration: 3) { [weak self] in
            switch type {
            case .normal:
                self?.originalLayout()
            case .keynote:
                self?.keynoteLayout()
            }
        }
    }
    
    enum TVLayoutType {
        case normal
        case keynote
    }
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if string == "" {return nil}
        
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
        UIView.animate(withDuration: 1, animations: {
            
            self.titleLabel.text = message.title
            self.subTitleLabel.text = message.subtitle
            self.descriptionLabel.text = message.description
            self.locationLabel.text = message.location
            self.qrCodeImage.image = self.generateQRCode(from: message.url?.absoluteString ?? "")
            self.dateLabel.text = message.date.day
            self.timeLabel.text = message.date.time
            
            
            if self.dateLabel.text == nil && self.timeLabel.text == nil {
                self.whenLabel.text = ""
            }else {
                self.whenLabel.text = "When"
            }
    
            if self.locationLabel.text == nil {
                self.whereLabel.text = ""
            }else {
                self.whereLabel.text = "Where"
            }
            
        })
    }
    
    
    func switchMessages() {
        let messages = self.globalMessages
        
        var next = 0
        
        func nextIndex() -> Int {
            let index: Int
            if next >= 0 && next < messages.count {
                index = next
                next = next + 1
                return index
            }else {
                next = 0
                return nextIndex()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { (timer) in
            let index = nextIndex()
            print("will show messages[\(index)]")
            self.set(message: messages[index])
        }
        
    }

}
