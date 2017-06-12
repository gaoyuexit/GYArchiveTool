//
//  AppDelegate.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/2/12.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit
import LPDebug
import LPNetworkManager
import QuickForm
import LPFramework
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var application: UIApplication!
    var launchOptions: [UIApplicationLaunchOptionsKey: Any]?

    let notificationHandler = NotificationHandler()
    let inPurchase = Inpurchase.default
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.application = application
        self.launchOptions = launchOptions
        
        configNetwork()
        AppConfigurationHelper.default.initialize()
        checkoutUnFinishPurchase()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = EnterManager.enter()
        window?.makeKeyAndVisible()
        
//        setupDebug()
        setupAppearance()
        setUpPlatformLogin()
        setupBPush(application, launchOptions: launchOptions)
        setupUMeng()
        
        if !isTestServer { MDAnalyticsTool.startAnalytic() }
        // 清理视频缓存 最大缓存
        LPPlayerCacheManager.shared.maxDiskCacheSize = UInt(80 * 1000 * 1000)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupPush), name: NSNotification.Name.User.login, object: nil)
        
        return true
    }
    
    func setupPush() {
        setupBPush(application, launchOptions: launchOptions)
    }
    
    func setupUMeng() {
        Social.startUmengSocial(umengKey, wechat: (wechatAppId,wechatAppSecret), qq: (qqAppId,nil), sina: (sinaAppId,sinaAppSecret))
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
//        PingPPPayManager.shared.handleOpenURL(url: url)
        
        UMSocialManager.default().handleOpen(url)
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        PingPPPayManager.shared.handleOpenURL(url: url)
        
        UMSocialManager.default().handleOpen(url, sourceApplication: sourceApplication, annotation: annotation)
     
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // 第三方支付未完成切回来, 让菊花消失
        dismissLoading()
        // 比如有推送了, 但是用户没有点击推送, 直接点进来/或者home键进来, 也要刷新会话列表
        NotificationCenter.default.post(name: NSNotification.Name.receiveMessageRemote, object: nil)
    }
    
    /// 当用户接受或拒绝请求许可 调用
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        BPush.registerDeviceToken(deviceToken)
        BPush.bindChannel { (result, error) in
            
            if error != nil { return }
            let myChannelId = Int64(BPush.getChannelId())
            let myUserId = Int64(BPush.getUserId())
            if userManager.account != nil {
                self.updateRemoteNotificationsInfo(RemoteNotifications(channelId: myChannelId, userId: myUserId))
            }
            if (result != nil) {
                DispatchQueue.main.async {
                    BPush.setTag("Mytag", withCompleteHandler: { (result, error) in
                        if result != nil {
                            //print("设置tag成功")
                        }
                    })
                }
            }
        }
    }
    
    /// 用于静默推送 iOS7以后出现, 不会出现提醒及声音 让程序自己执行一些操作，不管用户是否点击推送 暂时用不到
    /// iOS8和iOS9 也可以再该方法中获取到接受到的通知
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        notificationHandler.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
    
}

private extension AppDelegate {
    
    func setupCustomHeader() -> [String: String] {
        var header = [String: String]()
        if let accountID = userManager.account?.accountID {
            header["account-id"] = String(accountID)
        }
        if let token = userManager.account?.token {
            header["token"] = token
        }
        return header
    }
    
    func setupDebug() {
        LPDebug.shared.assistiveTouch.show()
        LPDebug.shared.debugItems = [.changeServer(block: { test in
            isTestServer = test
            
        }), .debugEntrance(controllers: debugControllers()), .hideDebug]
    }
    
    func configNetwork() {
        LPNetworkManager.config.baseURL = baseURLString
        LPNetworkManager.config.customHeader = setupCustomHeader
        LPNetworkManager.config.timeoutInterval = requestTimeOut
        LPNetworkManager.config.toastBlock = showToast
        LPNetworkManager.config.failToastString = requestFaildString
//        LPNetworkManager.config.debugNetwork = [.all: { print($0) }]
        LPNetworkManager.config.signKey = signKey
        LPNetworkManager.config.loadingViewType = MDAcitivityView.self
    }
    
    func setupAppearance() {
        // Input
        UITextField.appearance().tintColor = UIColor.mainColor
        UITextView.appearance().tintColor = UIColor.mainColor
        // Form
        FormUIStyle.separatorHorrizonOffset = Offset(left: 15, right: 0)
        FormUIStyle.titleColor = UIColor.mainTitleColor
        FormUIStyle.contentColor = UIColor.placeholderTitleColor
        FormUIStyle.disableContentColor = UIColor.placeholderTitleColor
        FormUIStyle.titleFont = UIFont.font32
        FormUIStyle.contentFont = UIFont.font32
        FormUIStyle.separatorColor = UIColor.separatorColor
        
        SimpleTitleRow.defaultRowInitializer = {
            $0.contentOffset = Offset(top: 14, left: 100, bottom: 23)
            $0.defaultHeight = 65
            $0.hideSectionLastSeparator = false
        }
        
        SimpleTitleRow.defaultCellSetup = { cell, _ in
            cell.backgroundColor = .backgroundColor
            cell.setSelectedBackgroundView()
        }
        
        // EmptyView
        SimpleEmptyData.defaultSetup = {
            $0.title = String(key: .networkErrorEmpty)
            $0.yAdjust = 50
        }
        SimpleEmptyView.defaultSetup = {
            $0.label.font = .font32
            $0.label.textColor = UIColor.subColor
            $0.backgroundColor = UIColor.clear
        }
    }
    
    func setUpPlatformLogin() {
        UMSocialManager.default().umSocialAppkey = umengKey
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: wechatAppId, appSecret: wechatAppSecret, redirectURL: "http://mobile.umeng.com/social")
        UMSocialManager.default().setPlaform(UMSocialPlatformType.QQ, appKey: qqAppId, appSecret: nil, redirectURL: "http://mobile.umeng.com/social")
        UMSocialManager.default().setPlaform(UMSocialPlatformType.sina, appKey: sinaAppId, appSecret: sinaAppSecret, redirectURL: "https://sns.whalecloud.com/sina2/callback")
    }
    
    func setupBPush(_ application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey: Any]?){
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = notificationHandler
            center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
                if granted {
                    application.registerForRemoteNotifications()
                }
            })
        }else {
            let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        if isTestServer {
            BPush.registerChannel(launchOptions, apiKey: kBPushAPIKey, pushMode: .production, withFirstAction: "打开", withSecondAction: "回复", withCategory: "test", useBehaviorTextInput: true, isDebug: true)
        }else{
            BPush.registerChannel(launchOptions, apiKey: kBPushAPIKey, pushMode: .production, withFirstAction: "打开", withSecondAction: "回复", withCategory: "test", useBehaviorTextInput: true, isDebug: true)
        }
        // 禁用地理位置推送 需要再绑定接口前调用
        BPush.disableLbs()
        /*
        let userInfo: [String: Any]? = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String : Any]
        if userInfo != nil {
            BPush.handleNotification(userInfo)
            remoteNotificationToSwitch(userInfo!)
        }
        */
        application.applicationIconBadgeNumber = 0
    }
    
    func updateRemoteNotificationsInfo(_ remoteNotifications: RemoteNotifications){
        guard let myUserId = remoteNotifications.userId else { return }
        guard let myChannelId = remoteNotifications.channelId else { return }
        LPNetworkManager.request(Router.registerPush(userID: myUserId, channelID: myChannelId))
    }
    
    func checkoutUnFinishPurchase() {
        
        Inpurchase.default.unFinishedTransaction = { (receipt, transaction, queue) in
            
            let data = InpurchaseAPIData(accountID: transaction.payment.applicationUsername,
                                         transactionID: transaction.transactionIdentifier,
                                         receiptData: receipt)
            LPNetworkManager.request(Router.verifyReceipt(data)).success {
                queue.finishTransaction(transaction)

                guard let id = userManager.account?.accountID else { return }
                LPNetworkManager.request(Router.accountDetail(id.description)).success { (account: Account) in
                    userManager.updateAccount(account: account)
                }.fail {
                    print("向服务器发送凭证失败")
                }
            }
        }
    }

}











