//
//  UITabBarExtensions.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/3/15.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import Foundation


extension UIViewController {
    
    @discardableResult
    func showTabBarBadge(on ItemIndex: Int, count: Int, offset: CGFloat = -5) -> UIButton? {
       return self.tabBarController?.tabBar.showBadge(on: ItemIndex, count: count, offset: offset)
    }
    func hideTabBarBadge(on ItemIndex: Int) {
        self.tabBarController?.tabBar.hideBadge(on: ItemIndex)
    }
}

private extension UITabBar {
    
    @discardableResult
    func showBadge(on ItemIndex: Int, count: Int, offset: CGFloat = 0) -> UIButton? {
        guard let item = items?[ItemIndex] else { return nil}
        
        hideBadge(on: ItemIndex)
        //let itemW = bounds.width / CGFloat(items!.count)
        //61为相机的图片大小
        let itemW = (bounds.width - 61) / CGFloat(items!.count)
        let badgeH = CGFloat(10)
        let badgeX = itemW * (CGFloat(ItemIndex) + 0.5) + item.image!.size.width * 0.5 + offset
        let badgeY = bounds.height * 0.5 - badgeH * 0.5 - item.image!.size.width * 0.5
        let badge = UIButton(text: "\(count)", textColor: .gradientBeginColor, font: .font20)
        badge.titleLabel?.textAlignment = .left
        badge.tag = 8888 + ItemIndex
        let badgeW = getBadgeWidth(with: "\(count)", height: badgeH)
        badge.frame = CGRect(x: badgeX, y: badgeY, width: badgeW, height: badgeH)
        addSubview(badge)
        return badge
    }

    func hideBadge(on ItemIndex: Int){
        subviews.forEach{ v in
            if v.tag == 8888 + ItemIndex{ v.removeFromSuperview() }
        }
    }
    
    func getBadgeWidth(with text: String, height: CGFloat) -> CGFloat {
        let textW = (text as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                     height: height),
                                        options: NSStringDrawingOptions(rawValue: 0),
                                        attributes: [NSFontAttributeName: UIFont.font20],
                                        context: nil).size.width
        return max(textW, 10)
    }
}

