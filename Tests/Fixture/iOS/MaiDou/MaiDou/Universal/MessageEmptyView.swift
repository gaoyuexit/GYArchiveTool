//
//  MessageEmptyView.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/4/12.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit
import LPFramework

class MessageEmptyView: EmptyView<ButtonEmptyData> {

    public static var defaultSetup: ((MessageEmptyView)->Void)?
    
    public private(set) var iconView: UIImageView!
    public private(set) var titleLabel: UILabel!
    public private(set) var refreshButton: GradientButton!
    
    var yConstraint: NSLayoutConstraint!
    override public var data: ButtonEmptyData? {
        didSet {
            titleLabel.text = data?.title
            iconView.image = UIImage(named: data?.imageName ?? "")
            iconView.sizeToFit()
            
            refreshButton.setTitle(data?.buttonTitle, for: .normal)
            
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    required public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundColor
        iconView = UIImageView(frame: CGRect.zero)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconView)
        
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.placeholderTitleColor
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        refreshButton = GradientButton(type: .custom)
        refreshButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        refreshButton.setTitleColor(UIColor.white, for: .normal)
        refreshButton.backgroundColor = UIColor.blue
        refreshButton.layer.cornerRadius = 20
        refreshButton.layer.masksToBounds = true

        refreshButton.addTarget(self, action: #selector(buttonDidClicked(sender:)), for: .touchUpInside)
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(refreshButton)
        
        MessageEmptyView.defaultSetup?(self)
        
        // titleLabel
        
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-32)
            make.width.height.equalTo(73)
        }
        
        refreshButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalTo(45)
            make.right.equalTo(-45)
            make.height.equalTo(40)
            make.top.equalTo(titleLabel.snp.bottom).offset(35.5)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttonDidClicked(sender: UIButton) {
        data?.action?()
    }
}
