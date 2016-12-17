//
//  ClassExtensions.swift
//  WePeiYang
//
//  Created by Allen X on 8/12/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

/**
 This file is wrapping all extensions of classes 
 */

import UIKit
import Foundation

extension Double {
    func toRadians() -> CGFloat {
        return CGFloat(self * .pi / 180.0)
    }
}

extension UILabel {
    convenience init(text: String, color: UIColor) {
        self.init()
        self.text = text
        textColor = color
        self.sizeToFit()
    }
    
    convenience init(text: String?) {
        self.init()
        self.text = text
        self.sizeToFit()
    }
    
    convenience init(text: String, fontSize: CGFloat) {
        self.init()
        self.text = text
        self.font = UIFont.boldSystemFont(ofSize: fontSize)
        self.sizeToFit()
    }
}



extension UIView {
    convenience init(color: UIColor) {
        self.init()
        backgroundColor = color
    }
}

struct PixelData {
    var a: UInt8 = 0
    var r: UInt8 = 0
    var g: UInt8 = 0
    var b: UInt8 = 0
}


extension UIImage {
    
    static func resizedImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x: 0.0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    static func resizedImageKeepingRatio(image: UIImage, scaledToWidth newWidth: CGFloat) -> UIImage {
        let scaleRatio = newWidth / image.size.width
        let newHeight = image.size.height * scaleRatio
        let foo = UIImage.resizedImage(image: image, scaledToSize: CGSize(width: newWidth, height: newHeight))
        return foo
    }
    
    static func resizedImageKeepingRatio(image: UIImage, scaledToHeight newHeight: CGFloat) -> UIImage {
        let scaleRatio = newHeight / image.size.height
        let newWidth = image.size.width * scaleRatio
        let foo = UIImage.resizedImage(image: image, scaledToSize: CGSize(width: newWidth, height: newHeight))
        return foo
    }
    
    func rgb(atPos pos: CGPoint) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return (r, g, b, a)
    }
    
    func rgbUInt8(atPos pos: CGPoint) -> (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = UInt8(data[pixelInfo])
        let g = UInt8(data[pixelInfo+1])
        let b = UInt8(data[pixelInfo+2])
        let a = UInt8(data[pixelInfo+3])
        
        return (r, g, b, a)
    }
    
    
    func smartAvgRGB() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        //[TODO]: Add smart rgb Filter
        
        //Naïve Algorithm. Squareroot: Weight for a specific RGB value is value^(-1/3)
        let thumbnail = UIImage.resizedImage(image: self, scaledToSize: CGSize(width: 100, height: 100))
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        for i in 0..<100 {
            for j in 0..<100 {
                let point = CGPoint(x: i, y: j)
                let rgbOfThisPoint = thumbnail.rgb(atPos: point)
                
                r += (pow(rgbOfThisPoint.red, 1/3))/10000
                g += (pow(rgbOfThisPoint.green, 1/3))/10000
                b += (pow(rgbOfThisPoint.blue, 1/3))/10000
                a += rgbOfThisPoint.alpha/10000
            }
        }
        
        //print(r*255, g*255, b*255, a)
        return (r, g, b, a)
    }
    
    static func imageFrom(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    static func imageFromBitmap(pixels: [PixelData], width: Int, height: Int) -> UIImage? {
        assert(width > 0)
        assert(height > 0)
        
        let pixelDataSize = MemoryLayout<PixelData>.size
        assert(pixelDataSize == 4)
        assert(pixels.count == Int(width * height))
        
        let data: Data = pixels.withUnsafeBufferPointer {
            return Data(buffer: $0)
        }
        
        let cfdata = NSData(data: data) as CFData
        let provider: CGDataProvider! = CGDataProvider(data: cfdata)
        if provider == nil {
            print("CGDataProvider is not supposed to be nil")
            return nil
        }
        let cgimage: CGImage! = CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: width * pixelDataSize,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue),
            provider: provider,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        )
        if cgimage == nil {
            print("CGImage is not supposed to be nil")
            return nil
        }
        return UIImage(cgImage: cgimage)
    }
    
    //returns a clockwise-rotated UIImage
    func rotated(by degrees: Double, flipped: Bool = false) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let transform = CGAffineTransform(rotationAngle: degrees.toRadians())
        var rect = CGRect(origin: .zero, size: self.size).applying(transform)
        rect.origin = .zero
        
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        return renderer.image { renderContext in
            renderContext.cgContext.translateBy(x: rect.midX, y: rect.midY)
            renderContext.cgContext.rotate(by: degrees.toRadians())
            renderContext.cgContext.scaleBy(x: flipped ? -1.0 : 1.0, y: -1.0)
            
            let drawRect = CGRect(origin: CGPoint(x: -self.size.width/2, y: -self.size.height/2), size: self.size)
            renderContext.cgContext.draw(cgImage, in: drawRect)
        }
    }
    
}




extension UIImageView {
    convenience init?(imageName: String, desiredSize: CGSize) {
        guard var foo = UIImage(named: imageName) else {
            return nil
        }
        foo = UIImage.resizedImage(image: foo, scaledToSize: desiredSize)
        self.init()
        image = foo
    }
}




extension UIButton {
    convenience init(title: String) {
        self.init()
        setTitle(title, for: .normal)
        titleLabel?.sizeToFit()
    }
    
    
    convenience init?(backgroundImageName: String, desiredSize: CGSize) {
        guard var foo = UIImage(named: backgroundImageName) else {
            return nil
        }
        foo = UIImage.resizedImage(image: foo, scaledToSize: desiredSize)
        self.init()
        setBackgroundImage(foo, for: .normal)
    }
}
