//
//  UIFontExtensions.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/2/12.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit

extension UIFont {
    
    private static let dinFontName = "DINCondensed-Bold"
    private static let PingFangRegular = "PingFangSC-Regular"
    private static let PingFangLight = "PingFangSC-Light"
    private static let PingFangMedium = "PingFangSC-Medium"

    /// 造字工房悦圆
    private static let yueRoudName = "RTWSYueRoudGoDemo-Regular"

    ///////////////////////////////////////////////////////////////
    static var font140: UIFont {
        return UIFont.pingFangRegular(ofSize: 70)
    }
    static var font88: UIFont {
        return UIFont.pingFangRegular(ofSize: 44)
    }
    static var font60: UIFont {
        return UIFont.pingFangRegular(ofSize: 30)
    }
    static var font40: UIFont {
        return UIFont.pingFangRegular(ofSize: 20)
    }
    static var font38: UIFont {
        return UIFont.pingFangRegular(ofSize: 19)
    }
    static var font36: UIFont {
        return UIFont.pingFangRegular(ofSize: 18)
    }
    static var font34: UIFont {
        return UIFont.pingFangRegular(ofSize: 17)
    }
    static var font32: UIFont {
        return UIFont.pingFangRegular(ofSize: 16)
    }
    static var font30: UIFont {
        return UIFont.pingFangRegular(ofSize: 15)
    }
    static var font28: UIFont {
        return UIFont.pingFangRegular(ofSize: 14)
    }
    static var font26: UIFont {
        return UIFont.pingFangRegular(ofSize: 13)
    }
    static var font24: UIFont {
        return UIFont.pingFangRegular(ofSize: 12)
    }
    static var font22: UIFont {
        return UIFont.pingFangRegular(ofSize: 11)
    }
    static var font20: UIFont {
        return UIFont.pingFangRegular(ofSize: 10)
    }
    static var font52: UIFont {
        return UIFont.pingFangRegular(ofSize: 26)
    }
    ///////////////////////////////////////////////////////////////
    
    static var fontBold36: UIFont {
        return UIFont.PingFangMedium(ofSize: 18)
    }
    
    static var fontBold34: UIFont {
        return UIFont.PingFangMedium(ofSize: 17)
    }
    
    static var fontBold30: UIFont {
        return UIFont.PingFangMedium(ofSize: 15)
    }
    
    static var fontBold28: UIFont {
        return UIFont.PingFangMedium(ofSize: 14)
    }
    
    
    ///////////////////////////////////////////////////////////////
    static var fontLight52: UIFont {
        return UIFont.pingFangLight(ofSize: 26)
    }
    
    ///////////////////////////////////////////////////////////////
    static var boldDIN28: UIFont {
        return UIFont(name: dinFontName, size: 14)!
    }
    static var boldDIN60: UIFont {
        return UIFont(name: dinFontName, size: 30)!
    }
    static var boldDIN70: UIFont {
        return UIFont(name: dinFontName, size: 35)!
    }
    static var boldDIN80: UIFont {
        return UIFont(name: dinFontName, size: 40)!
    }
    static var boldDIN100: UIFont {
        return UIFont(name: dinFontName, size: 50)!
    }
    static var boldDIN140: UIFont {
        return UIFont(name: dinFontName, size: 70)!
    }
    
    ///////////////////////////////////////////////////////////////
    static var font36_YueRoud: UIFont {
        return UIFont(name: yueRoudName, size: 18)!
    }
    
    
    
    
    static func pingFangRegular(ofSize: CGFloat) -> UIFont {
        if let font = UIFont(name: UIFont.PingFangRegular, size: ofSize) {
            return font
        }else{
            return UIFont.systemFont(ofSize: ofSize)
        }
    }
    
    static func pingFangLight(ofSize: CGFloat) -> UIFont {
        if let font = UIFont(name: UIFont.PingFangLight, size: ofSize) {
            return font
        }else{
            return UIFont.systemFont(ofSize: ofSize)
        }
    }
    
    static func PingFangMedium(ofSize: CGFloat) -> UIFont {
        if let font = UIFont(name: UIFont.PingFangMedium, size: ofSize) {
            return font
        }else{
            return UIFont.boldSystemFont(ofSize: ofSize)
        }
    }
}
