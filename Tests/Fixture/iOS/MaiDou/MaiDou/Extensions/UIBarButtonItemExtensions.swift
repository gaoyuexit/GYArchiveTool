//
//  UIBarButtonItemExtensions.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/2/12.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    enum Position {
        case leftTop
        case leftBottom
        case rightTop
        case rightBottom
        case none
    }
    
    private struct AssociateBadgeKey {
        static var badgeKey = "badge"
    }
    
    private var badge: UIView? {
        set{
            objc_setAssociatedObject(self, &AssociateBadgeKey.badgeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &AssociateBadgeKey.badgeKey) as? UIView
        }
    }
    
    convenience init(target: Any?, action: Selector, image: UIImage?, highImage: UIImage?) {
        self.init()
        let btn = UIButton()
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.setBackgroundImage(image, for: .normal)
        btn.setBackgroundImage(highImage, for: .highlighted)
        btn.sizeToFit()
        customView = btn
    }
    
    func showBadge(position: Position, unreadMessageNumber: Int){
        badge?.removeFromSuperview()
        
        let tempBadge = UILabel()
        tempBadge.frame.size = CGSize(width: 12, height: 15)
        tempBadge.layer.cornerRadius = 3
        tempBadge.textColor = .subColor
        tempBadge.backgroundColor = .clear
        tempBadge.font = UIFont.font22
        tempBadge.text = unreadMessageNumber == 0 ? "" : "\(unreadMessageNumber)"
        badge = tempBadge
        
        customView?.addSubview(badge!)
        tempBadge.isHidden = false
        switch position {
        case .leftTop:
            tempBadge.center = CGPoint(x: 0, y: 0)
        case .leftBottom:
            tempBadge.center = CGPoint(x: 0, y: (customView?.bounds.size.height)!)
        case .rightTop:
            tempBadge.center = CGPoint(x: (customView?.bounds.size.width)!+5, y: 2)
        case .rightBottom:
            tempBadge.center = CGPoint(x: (customView?.bounds.size.width)!, y: (customView?.bounds.size.height)!)
        case .none:
            tempBadge.isHidden = true
        }
    }
    
    func hideBadge(){
        badge?.removeFromSuperview()
    }
}
