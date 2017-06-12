//
//  UIViewControllerExtension.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/2/12.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit

extension UIViewController: UIScrollViewDelegate {
    
    func topMostController() -> UIViewController {
        var topController = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController!
    }
    
    func queryControllerFromNavigationStack(queryContrlller: Swift.AnyClass) ->  [UIViewController] {
        let childControllers = self.navigationController!.childViewControllers
        var changeChildControllers = childControllers
        var isHave = false
        for controller in childControllers.reversed() {
            changeChildControllers.removeLast()
            
            if type(of: controller) === queryContrlller {
                isHave = true
                break
            }
        }
        
        if isHave {
            return changeChildControllers
        } else {
            return childControllers
        }
    }

    
    func compress(images: [UIImage]) -> [UIImage] {
        var smallImages: [UIImage] = []
        
        for i in 0..<images.count {
            autoreleasepool {
                if let data = UIImageJPEGRepresentation(images[i], 0.2) {
                    if let image = UIImage(data: data) {
                        smallImages.append(image)
                    }
                }
            }
        }
        return smallImages
    }
}
