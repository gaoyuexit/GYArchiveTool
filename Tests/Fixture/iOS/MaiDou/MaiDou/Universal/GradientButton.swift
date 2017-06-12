//
//  GradientButton.swift
//  AVFoundationDemo
//
//  Created by Han Shuai on 17/2/27.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit

class GradientButton: UIButton {
    var colors: [UIColor] = [UIColor(red: 0.98, green: 0.2745, blue: 0.729, alpha:1), UIColor(red: 0.2235, green: 0.68, blue: 0.9843, alpha:1)]
    
    //逆时针为正, -90..90
    var angle = 0.0
    
    private var highlightView: UIView!
    
    override var isEnabled: Bool {
        didSet{
            alpha = isEnabled ? 1.0 : 0.1
        }
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            super.backgroundColor = UIColor.black
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundColor = UIColor.black
        
        highlightView = UIView()
        highlightView.backgroundColor = .white
        highlightView.alpha = 0
        
        addSubview(highlightView)
        
        highlightView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard !colors.isEmpty else { return }
        
        let offset = tan(angle * M_PI / 180) / 2
        
        let startPoint = CGPoint(x: 0, y: 0.5 + offset)
        let endPoint = CGPoint(x: 1, y: 0.5 - offset)
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map { $0.cgColor }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlightView.alpha = 0.3
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlightView.alpha = 0
        super.touchesEnded(touches, with: event)
    }
}
