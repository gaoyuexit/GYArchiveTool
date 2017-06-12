//
//  BaseNavigationController.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/2/12.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit
import LPExtensions

class BaseNavigationController: UINavigationController {
    
    // 这里先这样写, 应该是让子控制器决定 return self.topViewController?.preferredStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if !self.viewControllers.isEmpty {
            viewController.hidesBottomBarWhenPushed = true
            
            let btn = UIButton(type: .custom)
            btn.setImage(#imageLiteral(resourceName: "nav_back"), for: .normal)
            btn.sizeToFit()
            btn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let attributes = [NSForegroundColorAttributeName: UIColor.naviTitleColor, NSFontAttributeName: UIFont.font32]
        navigationBar.titleTextAttributes = attributes
//        navigationBar.barTintColor = UIColor.clear
        navigationBar.tintColor = UIColor.naviTitleColor
//        navigationBar.isTranslucent = false
        
        
//        navigationBar.backIndicatorImage = #imageLiteral(resourceName: "nav_back").withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 50, bottom: -10, right: 0))
//        navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "nav_back").withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 50, bottom: -10, right: 0))
//        navigationBar.setTitleVerticalPositionAdjustment(-5, for: .default)
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer!.delegate = self
    }
    
    
    func backAction() {
        self.popViewController(animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK - BackButton
protocol BackButtonHandlerProtocol {
    func navigationShouldPopOnBackButton() -> Bool
}

extension BaseNavigationController: UINavigationBarDelegate {
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if self.viewControllers.count < (navigationBar.items?.count ?? 0) {
            return true
        }
        
        let shouldPop = (self.topViewController as? BackButtonHandlerProtocol)?.navigationShouldPopOnBackButton() ?? true
        
        if shouldPop {
            self.popViewController(animated: true)
        } else {
            navigationBar.subviews.forEach { subView in
                if subView.alpha < 1 {
                    UIView.animate(withDuration: 0.25, animations: {
                        subView.alpha = 1
                    })
                }
            }
        }
        
        return shouldPop
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
}



//extension UINavigationBar {
//    open override func sizeThatFits(_ size: CGSize) -> CGSize {
//        return CGSize(width: .screenWidth, height: 64)
//    }
//}

