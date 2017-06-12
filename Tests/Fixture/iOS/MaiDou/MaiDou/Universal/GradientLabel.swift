//
//  GradientLabel.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/4/20.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit

import UIKit

enum GradientType {
    case toRight,toBottom,toRightTop,toRightBottom
}

class GradientLabel: UILabel {
    var fromColor: UIColor = .gradientBeginColor
    var toColor: UIColor = .gradientEndColor
    
    var startPoint = CGPoint(x: 0, y: 0)
    var endPoint = CGPoint(x: 1, y: 1)
    
    var type: GradientType = .toRightBottom {
        didSet {
            switch type {
            case .toRight:
                startPoint = CGPoint(x: 0, y: 1)
                endPoint = CGPoint(x: 1, y: 1)
            case .toBottom:
                startPoint = CGPoint(x: 0.5, y: 0)
                endPoint = CGPoint(x: 0.5, y: 1)
            case .toRightTop:
                startPoint = CGPoint(x: 0, y: 1)
                endPoint = CGPoint(x: 1, y: 0)
            case .toRightBottom:
                startPoint = CGPoint(x: 0, y: 0)
                endPoint = CGPoint(x: 1, y: 1)
            }
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard fromColor != toColor else { return }
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.frame = frame
        
        gradient.colors = [fromColor.cgColor, toColor.cgColor]
        
        gradient.startPoint = startPoint
        
        gradient.endPoint = endPoint
        
        image(with: gradient)?.draw(in: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), blendMode: CGBlendMode.sourceAtop, alpha: 1)
    }
    
    private func image(with layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
