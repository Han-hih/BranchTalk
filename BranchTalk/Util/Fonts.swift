//
//  Fonts.swift
//  BranchTalk
//
//  Created by 황인호 on 1/2/24.
//

//Body Bold
//Body
//Caption
import UIKit

enum Font: String {
    case Regular = "SFPro-Regular"
    case Bold = "SFPro-Bold"
    
    func of(size: CGFloat, lineHeight: CGFloat? = nil) -> UIFont {
        guard let font = UIFont(name: self.rawValue, size: size) else {
                    fatalError("Font not found: \(self.rawValue)")
                }
        
        if let lineHeight = lineHeight {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = lineHeight
            paragraphStyle.maximumLineHeight = lineHeight
            
            let _: [NSAttributedString.Key: Any] = [
                .font: font,
                .paragraphStyle: paragraphStyle
            ]
            return UIFont(descriptor: font.fontDescriptor, size: size)
        }
        return font
    }

    static func title1Bold() -> UIFont {
        return Font.Bold.of(size: 22, lineHeight: 30)
    }
    
    static func title2Bold() -> UIFont {
        return Font.Bold.of(size: 14, lineHeight: 20)
    }
    
    static func bodyBold() -> UIFont {
        return Font.Regular.of(size: 13, lineHeight: 18)
    }
    
    static func body() -> UIFont {
        return Font.Regular.of(size: 13, lineHeight: 18)
    }

    static func caption() -> UIFont {
        return Font.Regular.of(size: 12, lineHeight: 18)
    }
}
