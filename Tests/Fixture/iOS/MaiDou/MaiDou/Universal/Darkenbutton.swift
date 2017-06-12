//
//  Darkenbutton.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/4/12.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit

class Darkenbutton: UIButton {
    
    override var isEnabled: Bool { didSet{ alpha = isEnabled ? 1.0 : 0.35 } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setTitleColor(UIColor.gradientBeginColor, for: .normal)
        setTitleColor(UIColor.gradientBeginColor60, for: .disabled)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height * 0.5
        layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
