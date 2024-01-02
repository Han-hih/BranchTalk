//
//  Colors.swift
//  BranchTalk
//
//  Created by 황인호 on 1/2/24.
//

import Foundation

enum Colors {
    case BrandGreen
    case BrandError
    case BrandInactive
    case BrandBlack
    case BrandGray
    case BrandWhite
    case TextPrimary
    case TextSecondary
    case BackgroundPrimary
    case BackgroundSecondary
    case ViewSeperator
    case ViewAlpha
    
    
    var CutsomColor: UIColor {
        switch self {
        case .BrandGreen:
            UIColor(hexCode: "#4AC645")
        case .BrandError:
            UIColor(hexCode: "#E9666B")
        case .BrandInactive:
            UIColor(hexCode: "#AAAAAA")
        case .BrandBlack:
            UIColor(hexCode: "#000000")
        case .BrandGray:
            UIColor(hexCode: "#DDDDDD")
        case .BrandWhite, .BackgroundSecondary:
            UIColor(hexCode: "#FFFFFF")
        case .TextPrimary:
            UIColor(hexCode: "#1C1C1C")
        case .TextSecondary:
            UIColor(hexCode: "#606060")
        case .BackgroundPrimary:
            UIColor(hexCode: "#F6F6F6")
        case .ViewSeperator:
            UIColor(hexCode: "#ECECEC")
        case .ViewAlpha:
            UIColor(hexCode: "#00000080", alpha: 0.5)
        }
    }
}

extension UIColor {
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
