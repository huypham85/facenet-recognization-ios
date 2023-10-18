//
//  UIColor+Extension.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 09/10/2023.
//

import Foundation

extension UIColor {
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
        
    @nonobjc class var red400: UIColor {
        return UIColor(hexString: "#F6928A")
    }
    
    @nonobjc class var red600: UIColor {
        return UIColor(hexString: "#ED5D51")
    }
    
    @nonobjc class var primaryBrown: UIColor {
        return UIColor(hexString: "#57423E")
    }
    
    @nonobjc class var secondaryBrown: UIColor {
        return UIColor(hexString: "#BFA6A2")
    }
    
    @nonobjc class var lightGreen: UIColor {
        return UIColor(hexString: "#8ce515")
    }
    
    @nonobjc class var darkGreen: UIColor {
        return UIColor(hexString: "#316700")
    }
    
    
}
