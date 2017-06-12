//
//  GlobalFunctions.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/2/12.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit
import Toast_Swift
import SDCAlertView

// MARK: - Alert

func alertController(title: String?,
                     message: String? = nil,
                     dismissOnTap: Bool = true,
                     normalTextColortextColor: UIColor = .mainColor,
                     titleAttributes: [String: Any] = [NSFontAttributeName: UIFont.systemFont(ofSize: 16),
                                                       NSForegroundColorAttributeName: UIColor.mainColor],
                     messageAttributes: [String: Any] = [NSFontAttributeName: UIFont.systemFont(ofSize: 16),
                                                         NSForegroundColorAttributeName: UIColor.mainColor]) -> AlertController {
//    let titleAttributes: [String: Any] = [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor.black]
//    let messageAttributes: [String: Any] = [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor.black]
    
    let visualStyle = AlertVisualStyle(alertStyle: .alert)
    visualStyle.cornerRadius = 5
//    visualStyle.contentPadding = UIEdgeInsets(top: 20, left: 16, bottom: 12, right: 16)
    
    visualStyle.actionViewSeparatorColor = .backgroundColor
    visualStyle.backgroundColor = UIColor.popupBGColor_3F434C
    visualStyle.alertNormalFont = UIFont.systemFont(ofSize: 16)
    visualStyle.alertPreferredFont = UIFont.systemFont(ofSize: 16)
    visualStyle.normalTextColor = normalTextColortextColor
    visualStyle.verticalElementSpacing = 20
    visualStyle.textFieldHeight = 30
    visualStyle.textFieldBorderColor = UIColor.separatorColor
    
    let attributeTitle: NSAttributedString? = (title == nil) ? nil : NSAttributedString(string: title!, attributes: titleAttributes)
    let attributeMessage: NSAttributedString? = (message == nil) ? nil : NSAttributedString(string: message!, attributes: messageAttributes)
    
    let alert = AlertController(attributedTitle: attributeTitle, attributedMessage: attributeMessage, preferredStyle: .alert)
    alert.visualStyle = visualStyle
    
    if dismissOnTap {
        alert.behaviors = alert.behaviors?.union(.DismissOnOutsideTap)
    }
    
    return alert
}

// MARK: - Toast & Loading

extension UIView {
    func showToast(_ toastString: String) {
        var style = ToastStyle()
        style.cornerRadius = 5
       
        makeToast(toastString, duration: 1, position: .center, style: style)
    }
}

func showToast(_ toastString: String) {
    if let window = UIApplication.shared.windows.first {
        var style = ToastStyle()
        style.cornerRadius = 5
        window.makeToast(toastString, duration: 1, position: .center, style: style)
    }
}

//extension UIView {
//    static var progressKey = "com.loopeer.progressKey"
//    func showProgress(_ progress: CGFloat){
//        if let _ = objc_getAssociatedObject(self, &progressKey) as? DownLoadProgressView {
//            let progressView = DownLoadProgressView()
//            addSubview(progressView)
//            addConstraint(NSLayoutConstraint(item: activityView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
//            addConstraint(NSLayoutConstraint(item: activityView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
//            
//            return
//        }
//
//    }
//}

func loading() {
    UIApplication.shared.windows.first?.makeToastActivity(.center)
}

func dismissLoading() {
    UIApplication.shared.windows.first?.hideToastActivity()
}

func loadingSystemActivity() {
    UIApplication.shared.windows.first?.showSystemActivityLoading()
}

func dismissSystemActivity() {
    UIApplication.shared.windows.first?.hideSystemActivityLoading()
}

