//
//  DebugEntrance.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/2/12.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit

func debugControllers() -> [(String, UIViewController.Type)] {
    var array: [(String, UIViewController.Type)] = []
    
    array.append(("登陆主页", LoginViewController.self))
    array.append(("手机登录", PhoneLoginViewController.self))
    array.append(("设置昵称", NickNameViewController.self))
    array.append(("消息详情", MessageDetailViewController.self))
    array.append(("交易记录", PointRecordViewController.self))
    return array
}
