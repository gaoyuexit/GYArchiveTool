//
//  ScrollViewEmptyExtension.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/2/12.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import Foundation
import MJRefresh

extension UIScrollView {
    
    func endRefreshing(resetToPageZero: Bool, hasMore: Bool) {
        guard self.mj_footer != nil else { fatalError() }
        
        if resetToPageZero {
            self.mj_header.endRefreshing()
        }
        
        if hasMore  {
            self.mj_footer.endRefreshing()
            self.mj_footer.isHidden = false
        } else {
            self.mj_footer.endRefreshingWithNoMoreData()
            self.mj_footer.isHidden = true
        }
    }
}




