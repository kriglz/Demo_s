//
//  UIImage+Extension.swift
//  Demo-SceneKitNodeGrid
//
//  Created by Kristina Gelzinyte on 8/9/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit

extension UIImage {
    
    func pixelColorData() -> [UIColor] {
        guard let pixelData = self.cgImage?.dataProvider?.data else {
            return []
        }
        
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        var pixelColors: [UIColor] = []
        
        let pixelsWidth = Int(self.size.width)
        let pixelsHigh = Int(self.size.height)
        
        for x in 0..<pixelsWidth {
            
            for y in 0..<pixelsHigh {
                
                let pixelIndex: Int = ((pixelsWidth * y) + x) * 4
                
                let red = CGFloat(data[pixelIndex])
                let green = CGFloat(data[pixelIndex + 1])
                let blue = CGFloat(data[pixelIndex + 2])
                let alpha = CGFloat(data[pixelIndex + 3])
                
                let color = UIColor(r: red, g: green, b: blue, alpha: alpha)
                
                pixelColors.append(color)
            }
        }
        
        return pixelColors
    }
    
    func compress(to size: CGSize) -> UIImage? {
        let currentSize = self.size
        let scale = currentSize.width / currentSize.height
        
        var compressQuality: CGFloat
        
        if scale < 1 {
            compressQuality = size.height / currentSize.height
        } else {
            compressQuality = size.width / currentSize.width
        }
        
        if let data = UIImageJPEGRepresentation(self, compressQuality) {
            return UIImage(data: data)
        }
        
        return nil
    }
    
    func scale(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, 1)
        self.draw(in: CGRect(origin: .zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha / 255.0)
    }
}
