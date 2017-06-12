//
//  APIRouter.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/2/12.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit
import LPNetworkManager

struct PageStruct {
    var page: Int
    var size: Int
    var api: LPRequestParams { return ["page": page, "page_size": size] }
    
    init(_ page: Int, _ size: Int) {
        self.page = page
        self.size = size
    }
}

enum Router: LPRequestConvertible {
    /// 初始化
    case initialize
    /// 获取验证码
    case captcha(phone: String)
    /// 手机号登陆
    case phoneLogin(phone: String, captcha: String)
    /// 第三方登录
    case thirdLogin(ThirdLogin)
    /// 首页消息列表
    case chatList(offset: Int)
    /// 美刻商品点数列表
    case product
    /// 搜索
    case search(String, PageStruct)
    /// 获取我的粉丝(关注)列表
    case followList(AccountType, PageStruct)
    /// 获取单个用户详情
    case accountDetail(String)
    /// 发布消息
    case messageAdd(resourceType: Int, key: String, content: String, point: Int, fanIDs: [Int], type: Int)
    /// 回复消息 groupChatAccountID: 会话归属用户id  receiveAccountID回复的用户id
    case replyMessage(resourceType: Int, key: String, content: String, point: Int, groupChat: String, groupChatAccountID: String, receiveAccountID: String)
    /// 获取消息详情
    case messageDetail(String)
    /// 发现更多列表
    case foundList(offset: Int,pageSize: Int)
    /// 获取人气推荐列表
    case hotList
    /// 关注（取消关注）
    case follow(id: Int, type: FollowType)
    /// 交易记录
    case pointRecordList(PageStruct)
    /// 意见反馈
    case feedback(content: String, contact: String)
    /// 用户资料更新
    case accountUpdate(AccountUpdate)
    /// 关注消息设定 resourceKey: 七牛key
    case sayhi(resourceKey: String?, content: String?, action: SayHiAction)
    /// 解锁消息产生美刻交易
    case deblockMessage(messageID: String, groupChat: String)
    /// 购买点数
    case accountOrder(id: String, amount: String, payWay: String)
    /// 举报
    case report(String, String)
    /// 删除消息
    case messageDelete(String)
    /// 注册推送设备
    case registerPush(userID: Int64, channelID: Int64)
    /// 未读消息
    case messageCount
    /// 内购买
    case verifyReceipt(InpurchaseAPIData)
    /// 加入或者取消加入黑名单
    case joinOrCancelBlcak(Int)
    /// 获取黑名单列表
    case blackList(PageStruct)
    
    var requestData: (path: String, params: LPRequestParams?, method: LPHTTPMethod) {
        switch self {
        case .initialize:
            return ("/api/v1/system/initialize", nil, .get)
        case .captcha(let phone):
            return ("/api/v1/account/captcha", ["phone": phone], .get)
        case .thirdLogin(let thirdLogin):
            return ("/api/v1/account/loginByOpen", thirdLogin.params, .post)
        case .phoneLogin(let phone, let captcha):
            return ("/api/v1/account/login", ["phone": phone, "captcha": captcha], .post)
        case .chatList(let offset):
            return ("/api/v1/chat", ["offset": offset, "page_size": 10], .get)
        case .product:
            return ("/api/v1/product", nil, .get)
        case .search(let param, let page):
            return ("/api/v1/account/search", ["content": param] + page.api, .get)
        case .followList(let type, let page):
            return ("/api/v1/follow", ["type": type.rawValue] + page.api, .get)
        case .accountDetail(let id):
            return ("/api/v1/account/detail", ["account_id": id], .get)
        case .messageAdd(let resourceType, let key, let content, let point, let fanIDs, let action):
            var params: [String: Any] = ["resource_type": resourceType, "resource_url": key]
            params["content"] = content
            params["point"] = point
            params["fan_ids"] = fanIDs
            params["action"] = action
            return ("/api/v1/message", params, .post)
        case .replyMessage(let resourceType, let key, let content, let point, let groupChat, let groupChatAccountID, let receiveAccountID):
            var params: [String: Any] = ["resource_type": resourceType, "resource_url": key]
            params["content"] = content
            params["point"] = point
            params["group_chat"] = groupChat
            params["group_chat_account_id"] = groupChatAccountID
            params["receive_account_id"] = receiveAccountID
            return ("/api/v1/message/reply", params, .post)
        case .messageDetail(let postID):
            return ("/api/v1/chat/\(postID)", [:], .get)
        case .foundList(let offset,let pageSize):
            return ("/api/v1/account/foundList", ["offset": offset, "page_size": pageSize], .get)
        case .hotList:
            return ("/api/v1/follow/hot", [:], .get)
        case .follow(let id, let type):
            return ("/api/v1/follow", ["follow_account_id": id, "type": type.rawValue], .post)
        case .pointRecordList(let page):
            return ("/api/v1/account/pointRecordList", page.api, .get)
        case .feedback(let content, let contact):
            return ("/api/v1/system/feedback", ["content": content, "contact": contact], .post)
        case .accountUpdate(let update):
            return ("/api/v1/account/update", update.params, .post)
        case .sayhi(let key, let content, let action):
            var params: [String: Any] = [String: Any]()
            params["resource_url"] = key
            params["content"] = content
            params["action"] = action.rawValue
            return ("/api/v1/message/sayHi", params, .post)
        case .deblockMessage(let messageID, let groupChat):
            return ("/api/v1/message/unlock", ["message_id": messageID, "group_chat": groupChat], .post)
        case .accountOrder(let id, let amount, let payWay):
            return ("/api/v1/account/order", ["product_id": id, "pay_way": payWay, "amount": amount], .post)
        case .report(let id, let reson):
            return ("/api/v1/system/report", ["report_account_id": id, "reason": reson], .post)
        case .messageDelete(let id):
            return ("/api/v1/chat/\(id)", [:], .delete)
        case .registerPush(let userID, let channelID):
            return ("/api/v1/system/registerPush", ["app_user_id": userID, "app_channel_id": channelID], .post)
        case .messageCount:
            return ("/api/v1/account/count", nil, .get)
        case .verifyReceipt(let data):
            return ("/api/v1/product/receipt", data.api, .post)
        case .joinOrCancelBlcak(let blackAccoutID):
            return ("/api/v1/account/black", ["black_account_id": blackAccoutID], .post)
        case .blackList(let page):
            return ("/api/v1/account/blackList", page.api, .get)
        }
    }
    
    var serializationType: LPSerializationType {
        
        switch self {
        case .messageAdd(_, _, _, _, _, _), .replyMessage(_, _, _, _, _, _, _):
            return .body
        default:
            return .plain
        }
    }
}
/// 内购买数据结构
struct InpurchaseAPIData {
    var accountID: String?
    var transactionID: String?
    var receiptData: String?
    
    var api: LPRequestParams {
        var params: LPRequestParams = [:]
        
         if let accountID = accountID,
            let transactionID = transactionID,
            let receiptData = receiptData {
            
            params["account_id"] = accountID
            params["transaction_id"] = transactionID
            params["receipt_data"] = receiptData
        }
        
        return params
    }
}

struct AccountUpdate {
    var cover: String?
    var avatar: String?
    var nickname: String?
    var introduction: String?
    var replyPoint: String?
    
    var newMessageNotice: Int?
    var replyNotice: Int?
    var followNotice: Int?
    var unlockNotice: Int?
    var messageDetailNotice: Int?

    var params: LPRequestParams {
        var param: LPRequestParams = [:]
        
        param["cover"] = cover
        param["avatar"] = avatar
        param["nickname"] = nickname
        param["introduction"] = introduction
        param["reply_point"] = replyPoint

        param["new_message_notice"] = newMessageNotice
        param["reply_notice"] = replyNotice
        param["follow_notice"] = followNotice
        param["unlock_notice"] = unlockNotice
        param["message_detail_notice"] = messageDetailNotice
        return param
    }
    
    init(cover: String? = nil, avatar: String? = nil, nickname: String? = nil, introduction: String? = nil, replyPoint: String? = nil,newMessageNotice: Int? = nil, replyNotice: Int? = nil, followNotice: Int? = nil, unlockNotice: Int? = nil, messageDetailNotice: Int? = nil) {
        self.cover = cover
        self.avatar = avatar
        self.nickname = nickname
        self.introduction = introduction
        self.replyPoint = replyPoint
        
        self.newMessageNotice = newMessageNotice
        self.replyNotice = replyNotice
        self.followNotice = followNotice
        self.unlockNotice = unlockNotice
        self.messageDetailNotice = messageDetailNotice
    }
}

struct ThirdLogin {
    
    enum RegisterWay: Int {
        case sina = 1
        case wechat = 2
        case qq = 3
    }
    
    /// 第三方平台唯一标示open_id
    var openId: String?
    /// 注册方式(1-微博 2-微信 3-qq)
    var registerWay: RegisterWay?
    var avatar: String?
    var nickName: String?
    
    
    init(avatar: String? = nil, nickName: String? = nil, openId: String? = nil, registerWay: RegisterWay? = nil) {
        self.avatar = avatar
        self.nickName = nickName
        self.openId = openId
        self.registerWay = registerWay
    }
    
    var params: LPRequestParams {
        var param: LPRequestParams = [:]

        param["open_id"] = openId
        param["register_way"] = registerWay?.rawValue
        param["avatar"] = avatar
        param["nickname"] = nickName
        
        return param
    }
}

extension Router {
    /// 粉丝(关注)列表类型
    enum AccountType: Int {
        case fans   = 0/// 粉丝
        case follow = 1/// 关注
    }
    /// 关注类型
    enum FollowType: Int {
        case follow = 0///去关注
        case cancel = 1///取消关注
    }
    enum SayHiAction: Int {
        case save = 0   /// 保存
        case delete = 1 /// 删除
    }
}

