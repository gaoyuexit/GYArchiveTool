//
//  Models.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/2/12.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import Foundation
import LPNetworkManager
import LPFramework

/// 账户
var publicKey: String? {
    return UserDefaults.standard.object(forKey: "publicKey") as? String
}

final class Account: AccountInfo,JSONSerializable {
    
    enum Status: Int {
        case normal     /// 正常
        case disable    /// 禁用
    }
    enum FollowStatus: Int {
        case noFollow   /// 未关注
        case followed   /// 已关注
    }
    
    let accountID: Int
    let token: String
    
    /// 封面
    let cover: URL?
    let phone: String
    let avatar: URL?
    let nickname: String
    
    /// 关于我
    let introduction: String?
    let openID: Int?
    var sayhi: Message?
    
    /// 设定回复所需的点数  -1为没有设置
    let replyPoint: Int
    /// 美刻点数总数量
    var point: Int
    /// 粉丝数量
    let fanNums: Int
    /// 关注的总数量
    let followNums: Int
    
    /// 关注状态(0-否, 1-是)
    var followStatus: FollowStatus
    /// 状态(0:正常 1:禁用)
    let status: Status
    
    ///是否接收新消息(0接收 1是不接收)
    var newMessageNotice: Bool
    ///是否接收回复消息 （0是接收  1是不接收）
    var replyNotice: Bool
    ///是否接收关注通知 （0是接收  1是不接收）
    var followNotice: Bool
    ///是否接收解锁消息通知(0是接收   1是不接收)
    var unlockNotice: Bool
    ///是否显示消息详情 （0是显示 1是不显示）
    var messageDetailNotice: Bool
    ///是否已经拉黑(0是未拉黑 1是已拉黑)
    var blackStatus: Bool
    
    var isSelf: Bool { return userManager.account?.accountID == accountID }
    
    init(json: JSON) {
        
        /// 这个为了适配黑名单返回的格式: 
        /**
         "account": {
         "id": "11",
         "avatar": null,
         "nickname": "\u5b87\u5b87"
         }
         */
        let accountJson = json["account"] == JSON.null ? json : json["account"]
        
        accountID = accountJson["id"].intValue
        token = accountJson["token"].stringValue
        cover = accountJson["cover"].url
        phone = accountJson["phone"].stringValue
        avatar = accountJson["avatar"].url
        nickname = accountJson["nickname"].stringValue
        introduction = accountJson["introduction"].string
        openID = accountJson["open_id"].int
        sayhi = accountJson["say_hi"] == JSON.null ? nil : Message(json: json["say_hi"])
        replyPoint = accountJson["reply_point"].intValue
        point = accountJson["point"].intValue
        fanNums = accountJson["fans_number"].intValue
        followNums = accountJson["follow_number"].intValue
        followStatus = FollowStatus(rawValue: accountJson["is_follow"].intValue)!
        status = Status(rawValue: accountJson["status"].intValue)!
        if let key = accountJson["public_key"].string {
            UserDefaults.standard.set(String(key.characters.reversed()), forKey: "publicKey")
            UserDefaults.standard.synchronize()
        }
        
        newMessageNotice = accountJson["new_message_notice"].intValue == 0
        replyNotice = accountJson["reply_notice"].intValue == 0
        followNotice = accountJson["follow_notice"].intValue == 0
        unlockNotice = accountJson["unlock_notice"].intValue == 0
        messageDetailNotice = accountJson["message_detail_notice"].intValue == 0
        blackStatus = accountJson["is_black"].boolValue
    }
    
    func encodeToDictionary() -> Dictionary<String, Any> {
 
        var dicValue = dictionaryValue()
        dicValue["id"] = accountID
        dicValue["cover"] = cover?.absoluteString
        dicValue["avatar"] = avatar?.absoluteString
        dicValue["open_id"] = openID
        dicValue["say_hi"] = sayhi?.dictionaryValue()
        dicValue["reply_point"] = replyPoint
        dicValue["fans_number"] = followNums
        dicValue["follow_number"] = followNums
        dicValue["follow_status"] = followStatus.rawValue
        dicValue["status"] = status.rawValue
        
        dicValue["new_message_notice"] = newMessageNotice
        dicValue["reply_notice"] = replyNotice
        dicValue["follow_notice"] = followNotice
        dicValue["unlock_notice"] = unlockNotice
        dicValue["message_detail_notice"] = messageDetailNotice
        return dicValue
    }

    convenience init?(decodeFromDictionary decoder: Dictionary<String, Any>?) {
        if let dic = decoder {
            self.init(json: JSON(dic))
        } else {
            return nil
        }
    }
}

extension Account {
    static var idKey: String {
        return "AccountIdKey"
    }
    
    static var followStatusKey: String {
        return "AccountFollowStatusKey"
    }
    
    func userInfo() -> [String: Any] {
        return [Account.idKey: accountID, Account.followStatusKey: followStatus]
    }
}

/// sayhi
struct Sayhi: JSONSerializable{
    
    let id: String
    // 资源类型(0-图片, 1-视频)
    let resourceType: Int
    let resourceURL: URL?
    let content: String?
    
    /// 资源的url
    var url: URL? {
        guard let publickKey = publicKey,
            let resourceStr = resourceURL?.absoluteString,
            let urlStr = RSAUtil.decryptString(resourceStr, publicKey: publickKey),
            let url = URL(string: urlStr) else {
                return resourceURL
        }
        return url
    }
    
    init(json: JSON) {
        id = json["id"].stringValue
        resourceType = json["resource_type"].intValue
        resourceURL = json["resource_url"].url
        content = json["content"].string
    }
    func dictionaryValue() -> [String : Any] {
        var dict = [String: Any]()
        dict["id"] = id
        dict["resource_type"] = resourceType
        dict["resource_url"] = resourceURL?.absoluteString
        return dict
    }
}

/// 粉丝或者关注
struct Follow: JSONSerializable{
    let id: String
    let account: Account
    let followAccount: Account
    init(json: JSON) {
        id = json["id"].stringValue
        account = Account(json: json["account"])
        followAccount = Account(json: json["follow_account"])
    }
}

/// 消息
struct Message: JSONSerializable {
    /// 资源类型
    enum ResourceType: Int {
        case photo
        case video
    }
    /// 消息的类型
    enum `Type` : Int {
        /// 发布的新消息
        case newIssue = 0
        /// 回复消息
        case reply
        /// sayhi
        case sayhi
    }
    
    /// 资源的url
    var url: URL? {
        guard let publickKey = publicKey,
            let resourceStr = resourceURL?.absoluteString,
            let urlStr = RSAUtil.decryptString(resourceStr, publicKey: publickKey),
            let url = URL(string: urlStr) else {
                return resourceURL
        }
        return url
    }
    
    let id: String
    let account: Account
    let resourceType: ResourceType
    let resourceURL: URL?
    /// 消息的描述
    let content: String?
    /// 解锁点数
    let point: Int
    
    /// 消息的类型(0是发布的新消息 1是回复消息)
    let type: Type
    
    /// FIXME: 待删除
    /// 该组消息的最初发送人id
    let parentAccountID: String
    
    init(json: JSON) {
        id = json["id"].stringValue
        account = Account(json: json["account"])
        resourceType = ResourceType(rawValue: json["resource_type"].intValue)!
        resourceURL = json["resource_url"].url
        content = json["content"].stringValue
        point = json["point"].intValue
        parentAccountID = json["parent_account_id"].stringValue
        type = Type(rawValue: json["type"].intValue)!
    }
    
    func dictionaryValue() -> [String : Any] {
        var dict = [String: Any]()
        dict["id"] = id
        dict["account_id"] = account.accountID
        dict["parent_account_id"] = parentAccountID
        dict["resource_type"] = resourceType.rawValue
        dict["resource_url"] = resourceURL?.absoluteString
        dict["content"] = content
        dict["point"] = point
        dict["account"] = account.encodeToDictionary()
        return dict
    }
    
}

/// `会话` 列表
struct Chat: JSONSerializable {
    
    let id: String
    /// 消息id
    let messageID: String
    /// 会话组
    let groupChat: String
    /// 会话归属用户id
    let groupChatAccoutID: String
    ///  状态(0-未解锁 1-已解锁)
    var payStatus: Int
    /// 会话时间
    let createdAt: TimeInterval
    /// 发送会话用户
    let account: Account
    /// 接收会话用户
    let receiveAccount: Account
    /// 接受会话用户的id
    let receiveAccountID: String
    /// 消息
    let message: Message
    
    init(json: JSON) {
        id = json["id"].stringValue
        messageID = json["message_id"].stringValue
        groupChat = json["group_chat"].stringValue
        groupChatAccoutID = json["group_chat_account_id"].stringValue
        payStatus = json["status"].intValue
        createdAt = json["created_at"].doubleValue
        account = Account(json: json["account"])
        receiveAccount = Account(json: json["receive_account"])
        receiveAccountID = json["receive_account_id"].stringValue
        message = Message(json: json["message"])
    }
}

/// 美刻
struct Products: JSONSerializable {
    /// ID
    let id: String
    /// 金额
    let amount: Int
    /// 名称
    let name: String
    /// 点数
    let point: Int
    /// 赠送点数
    let rewardPoint: Int
    /// 类型(0-无 1-热门 2-划算)
    let type: Int?
    /// IAP标示
    let productID: String
    
    init(json: JSON) {
        id = json["id"].stringValue
        productID = json["app_index_id"].stringValue
        amount = json["amount"].intValue
        name = json["name"].stringValue
        point = json["point"].intValue
        rewardPoint = json["reward_point"].intValue
        type = json["type"].lpInt
    }
}

struct PointRecord: JSONSerializable {
    
    /// 交易类型
    ///
    /// - pointGet: 购买美刻
    /// - unlockPay: 解开消息耗费美刻
    /// - replyPay: 回复消息耗费美刻
    /// - readGet: 消息阅读获得美刻
    /// - replyGet: 消息回复获得美刻
    enum PointRecordType: Int {
        case error = -1
        case pointGet
        case unlockPay
        case replyPay
        case readGet
        case replyGet
        var isPay: Bool {
            switch self {
            case .error, .replyPay, .unlockPay: return true
            default: return false
            }
        }
    }
    
    /// id
    let id: String
    
    /// 交易点数
    let point: Int
    
    /// 交易类型
    let type: PointRecordType
    
    /// 交易对象基本信息
    let account: Account
    
    /// 交易时间
    let createdAt: TimeInterval
    
    init(json: JSON) {
        id = json["id"].stringValue
        point = json["point"].intValue
        type = PointRecordType(rawValue: json["type"].lpInt ?? -1) ?? .error
        account = Account(json: json["account"])
        createdAt = json["created_at"].doubleValue
    }
}

/// 远程通知
struct RemoteNotifications {
    var channelId: Int64?
    var userId: Int64?
}


