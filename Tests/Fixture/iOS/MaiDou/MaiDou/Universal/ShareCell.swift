//
//  ShareCell.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/4/11.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit

class ShareCell: UICollectionViewCell {
    
    fileprivate var iconView = UIImageView()
    fileprivate var titleLabel = UILabel(textColor: .subTitleColor, font: .font24)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundColor
        titleLabel.textAlignment = .center
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        
        iconView.snp.makeConstraints { (make) in
            make.centerX.top.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    func update(model: ShareInviteCellModel) {
        iconView.image = model.icon
        titleLabel.text = model.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
