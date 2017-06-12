//
//  WebpProcessor.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/2/12.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import Foundation
import Kingfisher
import LPExtensions

struct WebpProcessor: ImageProcessor, CacheSerializer {
    
    let identifier: String
    
    let targetSize: CGSize
    
    let corner: CGFloat
    
    let backgroundColor: UIColor
    
    init(targetSize: CGSize, corner: CGFloat, backgroundColor: UIColor = .clear) {
        self.targetSize = targetSize
        self.corner     = corner
        self.identifier = "\(targetSize)-\(corner)-\(backgroundColor)"
        self.backgroundColor = backgroundColor
    }
    
    func data(with image: Image, original: Data?) -> Data? {
        return UIImagePNGRepresentation(image)
    }
    
    func image(with data: Data, options: KingfisherOptionsInfo?) -> Image? {
        return UIImage(data: data)
    }
    
    func process(item: ImageProcessItem, options: KingfisherOptionsInfo) -> Image? {
        switch item {
        case .image(let image):
            return image.lp.cornerImage(to: targetSize, contentMode: .scaleAspectFill, corner: corner, backGroundColor: backgroundColor)
        case .data(_):
            return (DefaultImageProcessor.default >> self).process(item: item, options: options)
        }
    }
}





