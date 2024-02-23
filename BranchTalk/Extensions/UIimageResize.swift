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

    func downSample(size: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage {
        let imageSourceOption = [kCGImageSourceShouldCache: false] as CFDictionary
        let data = self.jpegData(compressionQuality: 0.1)! as CFData
        let imageSource = CGImageSourceCreateWithData(data, imageSourceOption)!
        
        let maxPixel = max(size.width, size.height) * scale
        let downSampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixel
        ] as CFDictionary
        
        let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSampleOptions)!
        
        let newImage = UIImage(cgImage: downSampledImage)
        print("original Image: \(self), resize: \(newImage)")
        return newImage
    }
}
