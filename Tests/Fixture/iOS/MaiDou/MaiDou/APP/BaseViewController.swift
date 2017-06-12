
//  BaseViewController.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/2/12.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit
import LPNetworkManager
import SDCAlertView
import LPDebug
import LPExtensions

class BaseViewController: UIViewController {
        
    var navBackgroundView: UIView?
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveUserNotAuth), name: NotAuthorizedNotification, object: nil)
        if let navBackgroundView = navBackgroundView {
            view.bringSubview(toFront: navBackgroundView)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NotAuthorizedNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationItem.hidesBackButton = true
    }
    
//    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
//        LPDebug.shared.assistiveTouch.show()
//    }
}

extension BaseViewController {
    
    func showNavigationBarView(color: UIColor = .backgroundColor) {
        navBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: .screenWidth, height: 64))
        navBackgroundView?.backgroundColor = color
        view.addSubview(navBackgroundView!)
        navBackgroundView?.layerAddShadow()
    }
    
    func switchToLoginViewController() {
        let loginView = LoginViewController()
        
        UIApplication.shared.keyWindow?.rootViewController = BaseNavigationController(rootViewController: loginView)
        let anim = CATransition()
        anim.duration = 0.5
        anim.type = "rippleffect"
        UIApplication.shared.keyWindow?.layer.add(anim, forKey: nil)
    }
    
    func switchToMain(){
        UIApplication.shared.keyWindow?.rootViewController = MainViewController()
        let anim = CATransition()
        anim.duration = 0.5
        anim.type = "rippleffect"
        UIApplication.shared.keyWindow?.layer.add(anim, forKey: nil)
    }
    
    @objc func receiveUserNotAuth(notification: NSNotification) {
        userManager.logout()
        let alert = alertController(title: String(key: .loginAgainTips))
        alert.add(AlertAction(title: String(key: .settingCoinConfirm), style: .normal,  handler: { _ in
            self.switchToLoginViewController()
        }))
        alert.present()
    }
}



