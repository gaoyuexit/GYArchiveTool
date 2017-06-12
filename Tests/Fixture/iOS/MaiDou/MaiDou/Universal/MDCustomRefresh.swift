//
//  MDRefreshNormalHeader.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/4/14.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit
import MJRefresh

class MDRefreshNormalHeader: MJRefreshNormalHeader {

    override func prepare() {
        super.prepare()
        
        lastUpdatedTimeLabel.font = .font24
        stateLabel.font = .font24
        
        lastUpdatedTimeLabel.textColor = .placeholderTitleColor
        stateLabel.textColor = .placeholderTitleColor
    }
}

class MDRefreshBackNormalFooter: MJRefreshBackNormalFooter {
    
    override func prepare() {
        super.prepare()
        stateLabel.font = .font24
        stateLabel.textColor = .placeholderTitleColor
    }
}
