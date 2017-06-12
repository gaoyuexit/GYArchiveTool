//
//  AppConfigurationHelper.swift
//  MaiDou
//
//  Created by Jack on 3/7/17.
//  Copyright © 2017 Loopeer. All rights reserved.
//

import Foundation
import LPNetworkManager

class AppConfigurationHelper {
    static let `default` = AppConfigurationHelper()
    
    var upToken: String?

    var appstoreReviewing = true
    /// 最大回复点数
    var maxReplyPoint: Int?
    /// 最大解锁点数
    var maxUnlockPoint: Int?
    
    @objc func initialize() {
        LPNetworkManager.request(Router.initialize).success { (result: JSON) in
            self.upToken = result.parseData["up_token"].string
            self.appstoreReviewing = result.parseData["appstore_reviewing"].boolValue
            self.maxReplyPoint = result.parseData["custom_data"]["max_reply_point"].lpInt
            self.maxUnlockPoint = result.parseData["custom_data"]["max_unlock_point"].lpInt
            
            }.fail {
                let reloadTimer = Timer(timeInterval: 5, target: self, selector: #selector(self.initialize), userInfo: nil, repeats: false)
                RunLoop.main.add(reloadTimer, forMode: RunLoopMode.commonModes)
        }
    }
}
