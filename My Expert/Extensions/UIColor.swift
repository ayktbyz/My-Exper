//
//  UIColor.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 30.12.2023.
//

import UIKit

extension UIColor {
    class func vcBackgroundColor() -> UIColor {
        return UIColor.white
    }
    
    @nonobjc class var cobalt: UIColor {
        return UIColor(red: 29.0 / 255.0, green: 79.0 / 255.0, blue: 145.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var brownGrey: UIColor {
        return UIColor(red: 117.0 / 255.0, green: 116.0 / 255.0, blue: 112.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var beige: UIColor {
        return UIColor(red: 196.0 / 255.0, green: 195.0 / 255.0, blue: 193.0 / 255.0, alpha: 1.0)
    }
    
    func isWhite(threshold: CGFloat = 0.9) -> Bool {
        // RGB bileşenlerini al
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Eşik değeriyle karşılaştır
        return red > threshold && green > threshold && blue > threshold
    }
}

