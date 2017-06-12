//
//  DiscoverEmptyView.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/4/13.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit
import LPFramework

class DiscoverEmptyView: EmptyView<SimpleEmptyData> {
    
    public static var defaultSetup: ((DiscoverEmptyView) -> Void)?
    
    public private(set) var label: UILabel!
    public private(set) var iconView: UIImageView!
    var yConstraint: NSLayoutConstraint!
    
    override public var data: SimpleEmptyData? {
        didSet {
            label.text = data?.title
            iconView.image = UIImage(named: data?.imageName ?? "")
            iconView.sizeToFit()
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    public required init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundColor

        label = UILabel(frame: CGRect.zero)
        label.font = UIFont.font32
        label.textColor = UIColor.placeholderTitleColor
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        
        iconView = UIImageView(frame: CGRect.zero)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(iconView)
        
        DiscoverEmptyView.defaultSetup?(self)
        
        // iconView
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(164)
        }
        // label
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconView.snp.bottom).offset(34)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
