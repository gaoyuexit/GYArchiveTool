//
//  NotificationHandler.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/3/16.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {

    /// ios10 可设置是否在应用内弹出通知 本地-远程都调用 用于前台运行
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        /// ios10, 前台收到通知的效果呈现(声音/提醒/数字角标)
        // 收到推送的通知, 用来刷新消息列表
        // 调两次?
        let userInfo = notification.request.content.userInfo
        remoteNotificationToShow(userInfo)
        NotificationCenter.default.post(name: NSNotification.Name.receiveMessageRemote, object: nil)
        completionHandler(.badge)
    }
    /// ios10 点击推送消息回调 (本地-远程都会调用) 用于后台及程序退出
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if UIApplication.shared.applicationState != .active {
            remoteNotificationToSwitch(userInfo)
        }
        completionHandler()
    }
    
    /// 用于静默推送 iOS7以后出现, 不会出现提醒及声音 让程序自己执行一些操作，不管用户是否点击推送 暂时用不到
    /// iOS8和iOS9 也可以再该方法中获取到接受到的通知
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        /// iOS8, iOS9收到通知 前,后台走这里   iOS10不会走这里
        if application.applicationState == .active {
            // 收到推送的通知, 用来刷新消息列表
            NotificationCenter.default.post(name: NSNotification.Name.receiveMessageRemote, object: nil)
            remoteNotificationToShow(userInfo)
        }else{ // 在不活跃和kill状态 点进来跳转
            remoteNotificationToSwitch(userInfo)
        }
        completionHandler(.newData)
    }
    
    func remoteNotificationToSwitch(_ userInfo: [AnyHashable : Any]) {
        print(userInfo)
//        UIApplication.shared.applicationIconBadgeNumber = 0
        let groupChat = userInfo["group_chat"] as? String
        // 0为跳转会话详情 1为跳转粉丝列表
        let type = userInfo["type"] as? String
        
        let mainVc = UIApplication.shared.keyWindow?.rootViewController as! MainViewController
        let nav = mainVc.tabBarVc.selectedViewController as! BaseNavigationController
        let currentVc = nav.visibleViewController
        
        if let type = type {
            if type == "follow" {
             mainVc.dismiss() // 先移除侧滑栏效果
             nav.pushViewController(FollowersViewController(), animated: true)
             return
            }else if type == "unlock" {
                mainVc.dismiss() // 先移除侧滑栏效果
                nav.pushViewController(PointRecordViewController(), animated: true)
                return
            }
        }
        
        if let groupChat = groupChat{
            // 收到推送的通知, 用来刷新消息列表
            NotificationCenter.default.post(name: NSNotification.Name.receiveMessageRemote, object: nil)
            let messageDetailVc = MessageDetailViewController()
            messageDetailVc.groupChat = groupChat
            messageDetailVc.customTransition = CustomShowMessageAnimator()
            messageDetailVc.modalPresentationCapturesStatusBarAppearance = true
            currentVc?.present(messageDetailVc, animated: true, completion: nil)
        }
    }
    
    func remoteNotificationToShow(_ userInfo: [AnyHashable : Any]) {
//        UIApplication.shared.applicationIconBadgeNumber = 0
        // 前台收到远程通知刷新用户数据
        let mainVc = UIApplication.shared.keyWindow?.rootViewController as! MainViewController
        mainVc.tabBarVc.refreshAccount()
        let aps = userInfo["aps"] as? [AnyHashable : Any]
        if let alert = aps?["alert"] as? String {
            DispatchQueue.main.async {
                notificationBar.showNotification(message: alert)
            }
        }
    }
}


/**
  1.  关注你:
 [AnyHashable("description"): 大大关注了你, AnyHashable("type"): follow, AnyHashable("aps"): {
 alert = "\U5927\U5927\U5173\U6ce8\U4e86\U4f60";
 sound = default;
 }, AnyHashable("created_at"): 1495087947]
  2. 发送消息给你
 **/




