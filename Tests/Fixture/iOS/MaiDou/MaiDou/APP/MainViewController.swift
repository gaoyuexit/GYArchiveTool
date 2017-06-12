//
//  NotificationHandler.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/3/16.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit
import LPTransitions

class MainViewController: UIViewController {
    
    fileprivate var statusBarShouldBeHidden = false
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }
    override var prefersStatusBarHidden: Bool { return statusBarShouldBeHidden }
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    
    enum DrawerStatus {
        case opened
        case closed
    }
    
    fileprivate let drawerViewWidth = CGFloat(286)
    
    fileprivate var drawerStatus: DrawerStatus = .closed
    
    let tabBarVc = TabBarController()
    
    var drawerView: DrawerView!
    
    fileprivate let contentView = UIView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func statusBar(hidden: Bool) {
        statusBarShouldBeHidden = hidden
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
}

// MARK: - setupUI
private extension MainViewController {
    
    func setupUI() {
        drawerView = DrawerView(frame: CGRect(x: -drawerViewWidth, y: 0, width: drawerViewWidth, height: .screenHeight))
        drawerView.delegate = self
        
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        contentView.alpha = 0
    
        addChildViewController(tabBarVc)
        view.addSubview(tabBarVc.view)
        view.addSubview(contentView)
        view.addSubview(drawerView)

        let tapGes = UITapGestureRecognizer(target: self, action: #selector(maskTapAction))
        contentView.addGestureRecognizer(tapGes)
        
        let edgeGes = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeAction))
        edgeGes.edges = .left
        edgeGes.delegate = self
        view.addGestureRecognizer(edgeGes)
    
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        drawerView.addGestureRecognizer(panGes)
    }
}

// MARK: - Event
extension MainViewController {
    
    /// 遮罩点击
    func maskTapAction() {
        dismiss()
    }
    /// 边缘滑动
    func screenEdgeAction(ges: UIScreenEdgePanGestureRecognizer) {
        handleGesture(ges)
    }
    
    /// 处理松手时候的手势
    func handleStopGesture(with status: DrawerStatus) {
        switch status {
        case .opened: draw()
        case .closed: dismiss()
        }
    }
    /// 划出
    func draw(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.contentView.alpha = 1.0
            self.drawerView.transform = CGAffineTransform(translationX: self.drawerViewWidth, y: 0)
            self.tabBarVc.view.transform = CGAffineTransform(translationX: self.drawerViewWidth, y: 0)
        }, completion: nil)
        // 请求用户数据, 为了刷新用户的粉丝数量
        tabBarVc.refreshAccount()
    }
    /// 消失
    func dismiss() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: { 
            self.contentView.alpha = 0
            self.drawerView.transform = CGAffineTransform.identity
            self.tabBarVc.view.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    /// 平移手势
    func panAction(ges: UIPanGestureRecognizer) {
        handleGesture(ges)
    }
    /// 处理手势
    func handleGesture(_ ges: UIPanGestureRecognizer) {
        let point = ges.translation(in: ges.view)
        var transform = drawerView.transform.translatedBy(x: point.x, y: 0)
        if transform.tx > drawerViewWidth { transform.tx = drawerViewWidth }
        drawerView.transform = transform
        tabBarVc.view.transform = transform
        let offset = drawerView.frame.origin.x + drawerViewWidth
        
        self.contentView.alpha = offset / drawerViewWidth
        
        ges.setTranslation(.zero, in: ges.view)
        
        if ges.state == .ended || ges.state == .cancelled || ges.state == .failed {
            drawerStatus = ges.velocity(in: ges.view).x <= 0 ? .closed : .opened
            handleStopGesture(with: drawerStatus)
        }
    }
    /// 跳转其他控制器
    func pushTo(vc: UIViewController) {
        dismiss()
        (tabBarVc.selectedViewController as! BaseNavigationController).pushViewController(vc, animated: false)
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let currentNav = tabBarVc.selectedViewController as! BaseNavigationController
        return currentNav.childViewControllers.count == 1
    }
}

extension MainViewController: DrawerViewDelegate {
    
    /// 抽屉菜单点击
    func drawerView(didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: setCoin()
        case 1: switchToPointRecord()
        case 2: sayHi()
        case 3: moreSetting()
        default: break
        }
    }
    /// 点击头像和昵称区域去个人主页
    func drawerHeaderViewDidClickAvatarAndName() {
        pushTo(vc: MineProfileViewController())
        MDAnalyticsTool.log(event: .minePortraitClick)
    }
    /// 点击了我的粉丝
    func drawerHeaderViewDidClickMyFans(){
        let vc = FollowersViewController()
        vc.type = .fans
        pushTo(vc: vc)
        MDAnalyticsTool.log(event: .mineFansClick)
    }
    /// 点击了我的关注
    func drawerHeaderViewDidClickMyFollows(){
        let vc = FollowersViewController()
        vc.type = .follow
        pushTo(vc: vc)
        MDAnalyticsTool.log(event: .mineFollowerClick)
    }
}

// MARK: - privite mothed
extension MainViewController: SayHiAlertControllerDelegate {
    
    /// 设置点数
    func setCoin() {
        pushTo(vc: SetReplyCoinViewController())
        MDAnalyticsTool.log(event: .mineReplyMaidouClick)
    }
    /// 交易记录
    func switchToPointRecord() {
        pushTo(vc: PointRecordViewController())
        MDAnalyticsTool.log(event: .mineTransactionClick)
    }
    /// 关注消息
    func sayHi() {
        MDAnalyticsTool.log(event: .mineFollowMessageClick)
        guard userManager.account?.sayhi == nil else {
            // 已经录制过，跳转sayHi播放页面
            let playSaihiVc = ShowVideoPhotoController()
            playSaihiVc.recordType = .updateSayHi
            playSaihiVc.cameraReuslt = CameraResult(photo: nil, movieURL: nil)
            present(playSaihiVc, animated: true, completion: nil)
            return
        }
        let recordVc = RecordViewController()
        recordVc.recordType = .recordSayHi
        present(recordVc, animated: true, completion: nil)

    }
    /// 关注消息点击了 去设定
    func sayHiDidConfirm() {
       
        // 未录制过，跳转sayHi录制页面
        let cameraVc = RecordViewController()
        cameraVc.recordType = .recordSayHi
        present(cameraVc, animated: true, completion: nil)
    }
    /// 更多设置
    func moreSetting() {
        pushTo(vc: SettingViewController())
        MDAnalyticsTool.log(event: .mineSettingClick)
    }
}



