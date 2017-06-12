//
//  MDAcitivityView.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/5/9.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit
import LPNetworkManager

class MDAcitivityView: LoadingViewProtocol {
    var systemActivityView: UIActivityIndicatorView
    
    required init(with containerView: UIView) {
        systemActivityView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        systemActivityView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(systemActivityView)
        
        containerView.addConstraint(NSLayoutConstraint(item: systemActivityView, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: systemActivityView, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        systemActivityView.startAnimating()
    }
    
    func hide() {
        systemActivityView.stopAnimating()
        systemActivityView.removeFromSuperview()
    }
}
