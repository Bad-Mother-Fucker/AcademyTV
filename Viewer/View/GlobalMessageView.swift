//
//  GlobalMessageView.swift
//  Viewer
//
//  Created by Gianluca Orpello on 09/11/2018.
//  Copyright © 2018 Gianluca Orpello. All rights reserved.
//

import UIKit
import PureLayout

class GlobalMessageView: UIView {
 
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var descriptionLabel = UITextView()
    var timeLabel = UILabel()
    var locationLabel = UILabel()
    var dateLabel = UILabel()
    var whenLabel = UILabel()
    var whereLabel = UILabel()
    var nextMsg = 0
    
    
    var qrCodeImage = UIImageView()
    
    var globalMessages: [GlobalMessage] = [] {
        didSet {
            if globalMessages.count == 0 {
                set(message: .voidMessage)
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
        subviews.forEach { (view) in
            view.configureForAutoLayout()
        }
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        titleLabel.font = UIFont.systemFont(ofSize: 41, weight: .medium)
        titleLabel.textColor = .white
        subTitleLabel.font = UIFont.systemFont(ofSize: 20,weight: .medium)
        subTitleLabel.textColor = .white
        subTitleLabel.alpha = 0.5
        descriptionLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        descriptionLabel.textColor = .white
        
        timeLabel.font = UIFont.systemFont(ofSize: 23)
        timeLabel.textColor = .white
        dateLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        dateLabel.textColor = .white
        locationLabel.font = UIFont.systemFont(ofSize: 23)
        locationLabel.textColor = .white
        
        timeLabel.textAlignment = .center
        dateLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        locationLabel.numberOfLines = 0
        locationLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 0
        locationLabel.alpha = 0.5
        dateLabel.alpha = 0.5
        timeLabel.alpha = 0.5
        subTitleLabel.numberOfLines = 0
        
        descriptionLabel.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.addSubview(titleLabel)
        self.addSubview(timeLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(locationLabel)
        self.addSubview(qrCodeImage)
        self.addSubview(dateLabel)
        
       
        subviews.forEach { (view) in
            view.configureForAutoLayout()
        }
        
        
        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { (timer) in
            if self.globalMessages.count > 0 {
                let index = self.nextIndex()
                self.set(message: self.globalMessages[index])
//                self.scrollTextIfNeeded(in: self.descriptionLabel)
            }
        
        }
       
    }
    
    

    
    
    func layoutView() {

        //        View Layout
        autoPinEdgesToSuperviewEdges()
                
        //        Subtitle Layout
        subTitleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 30)
        subTitleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 30)
        subTitleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 35)

        //        Title Layout
        titleLabel.autoPinEdge(.left, to: .left, of: subTitleLabel)
        titleLabel.autoPinEdge(.right, to: .right, of: subTitleLabel)
        titleLabel.autoPinEdge(.top, to: .bottom, of: subTitleLabel)
       
        //QRCODE Layout
        
        qrCodeImage.autoSetDimensions(to: CGSize(width: 144, height: 144))
        qrCodeImage.autoPinEdge(toSuperviewEdge: .left, withInset: 30)
        qrCodeImage.autoPinEdge(.top, to: .bottom, of: titleLabel,withOffset: 20)

        //Date and time layout
        dateLabel.autoPinEdge(.left, to: .right, of: qrCodeImage,withOffset: 30)
        dateLabel.autoPinEdge(.top, to: .top, of: qrCodeImage)
        dateLabel.autoSetDimension(.height, toSize: 60)

        timeLabel.autoPinEdge(.left, to: .right, of: dateLabel,withOffset: 8)
        timeLabel.autoPinEdge(.top, to: .top, of: dateLabel)
        timeLabel.autoPinEdge(.bottom, to: .bottom, of: dateLabel)

        locationLabel.autoPinEdge(.left, to: .left, of: dateLabel)
        locationLabel.autoPinEdge(.top,to: .bottom, of: dateLabel)
        locationLabel.autoSetDimension(.height, toSize: 60)
        locationLabel.autoPinEdge(.right, to: .right, of: timeLabel)
        
        //Description Layout
        descriptionLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 30)
        descriptionLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 30)
        descriptionLabel.autoPinEdge(.top, to: .bottom, of: qrCodeImage,withOffset: 30)
        
    
        
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
        self.titleLabel.text = message.title
        self.subTitleLabel.text = message.subtitle.uppercased()
        self.descriptionLabel.text = message.description
        self.locationLabel.text = message.location
        self.qrCodeImage.image = self.generateQRCode(from: message.url?.absoluteString ?? "")
        self.dateLabel.text = message.date.day
        self.timeLabel.text = message.date.time
        
        if self.qrCodeImage.image == nil {
            dateLabel.removeFromSuperview()
            addSubview(dateLabel)

            dateLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 30)
            dateLabel.autoSetDimension(.height, toSize: 60)
            dateLabel.autoPinEdge(.top, to: .bottom, of: titleLabel,withOffset: 30)
            timeLabel.autoPinEdge(.left, to: .right, of: dateLabel,withOffset: 8)
            timeLabel.autoPinEdge(.top, to: .top, of: dateLabel)
            timeLabel.autoPinEdge(.bottom, to: .bottom, of: dateLabel)
            
            locationLabel.autoPinEdge(.left, to: .left, of: dateLabel)
            locationLabel.autoPinEdge(.top,to: .bottom, of: dateLabel)
            locationLabel.autoSetDimension(.height, toSize: 60)
            locationLabel.autoPinEdge(.right, to: .right, of: timeLabel)
        }else {
            dateLabel.removeFromSuperview()
            addSubview(dateLabel)
            dateLabel.autoPinEdge(.left, to: .right, of: qrCodeImage,withOffset: 30)
            dateLabel.autoPinEdge(.top, to: .top, of: qrCodeImage)
            dateLabel.autoSetDimension(.height, toSize: 60)
            timeLabel.autoPinEdge(.left, to: .right, of: dateLabel,withOffset: 8)
            timeLabel.autoPinEdge(.top, to: .top, of: dateLabel)
            timeLabel.autoPinEdge(.bottom, to: .bottom, of: dateLabel)
            
            locationLabel.autoPinEdge(.left, to: .left, of: dateLabel)
            locationLabel.autoPinEdge(.top,to: .bottom, of: dateLabel)
            locationLabel.autoSetDimension(.height, toSize: 60)
            locationLabel.autoPinEdge(.right, to: .right, of: timeLabel)

        }
        
    }
    
    
   
    
        func nextIndex() -> Int {
            let index: Int
            if nextMsg >= 0 && nextMsg < globalMessages.count {
                index = nextMsg
                nextMsg = nextMsg + 1
                return index
            }else {
                nextMsg = 0
                return nextIndex()
            }
        }
        
    
        
        
        func textExceedBoundsOf(_ textView: UITextView) -> Bool {
            let textHeight = textView.contentSize.height
            return textHeight > textView.bounds.height
        }
    
        
        func scrollTextIfNeeded(in textView: UITextView) {
            guard textExceedBoundsOf(textView) else {return}
            textView.scrollRangeToVisible(NSRange(location: 0, length: 0))
            var lastRange = NSRange(location: 0, length: 250)
            Timer.scheduledTimer(withTimeInterval: 6, repeats: true) { (timer) in
                guard self.textExceedBoundsOf(textView) else {
                    timer.invalidate()
                    return
                }
                let newRange = NSRange(location: lastRange.upperBound, length: 250)
                textView.scrollRangeToVisible(newRange)
                lastRange = newRange
            }
        }
        

    

}
