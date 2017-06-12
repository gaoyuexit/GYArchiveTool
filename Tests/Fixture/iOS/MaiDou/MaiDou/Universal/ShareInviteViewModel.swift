//
//  ShareInviteViewModel.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/4/11.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit

/// 类型
enum ShareInviteTpye {
    case share
    case invite
}

struct ShareInviteViewModel {
    
    /// 类型
    let type: ShareInviteTpye
    /// 标题
    var title: String { return type == .invite ? String(key: .inviteTitle) : String(key: .shareTitle) }
    /// 标题颜色
    var titleColor: UIColor { return type == .invite ? UIColor.gradientBeginColor : UIColor.mainColor }
    /// 标题大小
    var titleFont: UIFont { return type == .invite ? UIFont.font32 : UIFont.font34 }
    /// cellModels
    var cellModels: [ShareInviteCellModel] {
        return [
//            ShareInviteCellModel(icon: #imageLiteral(resourceName: "share_weibo"), title: String(key: .sinaWeiBo)),
            ShareInviteCellModel(icon: #imageLiteral(resourceName: "share_wechat"), title: String(key: .weChatFriend)),
            ShareInviteCellModel(icon: #imageLiteral(resourceName: "share_wechat_moments"), title: String(key: .friendCircle)),
            ShareInviteCellModel(icon: #imageLiteral(resourceName: "share_qq"), title: String(key: .qqFriend)),
            ShareInviteCellModel(icon: #imageLiteral(resourceName: "share_qzone"), title: String(key: .qqZone)),
            ShareInviteCellModel(icon: #imageLiteral(resourceName: "share_link"), title: String(key: .copyLink))
        ]
    }
    
    init(type: ShareInviteTpye) {
        self.type = type
    }
}

struct ShareInviteCellModel {
    /// icon
    let icon: UIImage
    /// title
    let title: String
}




