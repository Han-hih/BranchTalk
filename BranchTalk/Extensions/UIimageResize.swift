//
//  UIimageResize.swift
//  BranchTalk
//
//  Created by 황인호 on 1/27/24.
//

import UIKit

extension UIImage {
    func resize(_ width: Int, _ height: Int) -> UIImage {
        
        let size = CGSize(width: width, height: height)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }
}

