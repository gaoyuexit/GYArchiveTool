//
//  GlobalVariables.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/2/12.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import Foundation
import LPFramework

var isTestServer = false
let requestTimeOut: Double = 30
let baseURLString = isTestServer ? "http://maidou.17chuang.cc" : "https://meikeapp.cc"
let requestFaildString = String(key: .requestFaildStringToast)

let appStoreID = "1221263845"
let signKey = isTestServer ? "NuCA3jzGpJSgTWLwQ9EEAoWPvUFy9MWc" : "RSk2Cuy6xncnEAZ4MHQDZ29OmbNb7yUS"

let umengKey = "58c37bb9f29d9848ed000edf"
let wechatAppId = "wxf18e5caaf4b28c2b"
let wechatAppSecret = "86e0ddbaa09d16e5de96bbac6b6dc18f"
let qqAppId = "1106091377"
let sinaAppId = "3625175495"
let sinaAppSecret = "c1e07370226e911ea9ad24c51fb2ff59"

// 百度推送
let kBPushAPIKey = "4uFQ6wozdALQi67nYAZ8ICfM"
let kBPushSecretKey = "tXqePPT15NlP56r5KwHTgqlM99tk10IW"

// TalkingData
let talkingDataAppID = "83D1F949F86D4E929943E06A8E26BB66"
let talkingDataChannelID = "AppStore"


let userManager = UserManager<Account>()
let notificationBar = LPNotificationBar()

// Notification
extension Notification.Name {
    // 发通知时，需要携带 改变后的 Account Model
    static let followChanged = Notification.Name(rawValue: "com.loopeer.MaiDou.notification.followChanged")
    // 解锁消息付费成功的通知 用于刷新账户
    static let deblockMessage = Notification.Name(rawValue: "com.loopeer.MaiDou.notification.deblockMessage")
    // 回复成功的通知(包括付费和免费) 用于刷新账户
    static let replyMessage = Notification.Name(rawValue: "com.loopeer.MaiDou.notification.payReplyMessage")
    // 收到消息推送的通知
    static let receiveMessageRemote = Notification.Name(rawValue: "com.loopeer.MaiDou.notification.receiveMessageRemote")
    /// 解锁消息
    static let unlock = Notification.Name(rawValue: "com.loopeer.MaiDou.notification.unlock")
    /// 对sayhi进行操作了的通知, 服务端没有返回sayhi信息 ,要重新刷新用户
    static let sayhiAction = Notification.Name(rawValue: "com.loopeer.MaiDou.notification.sayhiAction")
    /// 对推送进行了设置
    static let pushSettingAction = Notification.Name(rawValue: "com.loopeer.MaiDou.notification.pushSettingAction")
}

// Guide
struct GuideKey {
    static let messageDetail = "GuideKey.messageDetail"
    
}







