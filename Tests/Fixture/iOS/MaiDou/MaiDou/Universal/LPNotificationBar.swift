//
//  LPNotificationBar.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/3/19.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit


class LPNotificationBar: UIWindow {

    struct NotificationBarConfig {
        
       /// 自动关闭时间
       static var autoCloseTime: Double = 0.5
       
        /// 默认图标
       /// var icon: UIImage?
       /// 标题
       /// static var title: String = "提示"
       
    }
    fileprivate var containView: UIView!
    fileprivate var messageLabel: UILabel!
    fileprivate var isShowing: Bool = false
    fileprivate var defaultWindow = UIApplication.shared.keyWindow
    
    init() {
        super.init(frame: CGRect(x: 0, y: 20 - 44, width: .screenWidth, height: 44))
        setupUI()
        windowLevel = UIWindowLevelNormal
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showNotification(message: String, id: String? = nil) {

        print("showNotification: \(isShowing)")
        guard !isShowing else { return }
        makeKeyAndVisible()
        defaultWindow?.makeKey()
        isShowing = true
        print("isShowing set TRUE")
        isHidden = false
        messageLabel.attributedText = message.lineSpacing(4, font: .font24, textColor: .white)
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: 44)
        }) { (finished) in
            self.perform(#selector(self.hide), with: self, afterDelay: NotificationBarConfig.autoCloseTime)
        }
    }
    
    func hide(){
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }) { (finished) in
            self.isHidden = true
            self.isShowing = false
            print("isShowing set False: \(finished)")
            self.defaultWindow?.makeKeyAndVisible()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containView.frame = bounds
    }
}

private extension LPNotificationBar {
    func setupUI(){

        containView = UIView()
        containView.backgroundColor = .notificationBarColor
        
        messageLabel = UILabel(attributedText: " ", textColor: .white, font: .font24, lineSpacing: 4)
        messageLabel.bounds = CGRect(x: 0, y: 0, width: .screenWidth - 30, height: 44 - 8)
        messageLabel.center = CGPoint(x: .screenWidth * 0.5, y: 22)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .left
        
        addSubview(containView)
        containView.addSubview(messageLabel)
    }
}


