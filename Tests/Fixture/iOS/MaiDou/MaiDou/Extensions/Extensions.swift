//
//  Extensions.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/2/12.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import LPExtensions
import Kingfisher

extension Int {
    var cgFloat: CGFloat {
        return self.constraintMultiplierTargetValue
    }
    /// 设计图上的大小的一半，方便查看
    var half: CGFloat {
        return self.cgFloat / 2
    }
    /// 按照6s尺寸适配的大小
    var adapt: CGFloat {
        let scale = CGFloat.screenWidth / 375.0
        return self.cgFloat * scale
    }
    /// 添加视图Tag
    var aTag: Int { return self + 666 }
    /// 得到实际值
    var dTag: Int { return self - 666 }
}

extension CGFloat {
    /// 状态栏高度
    static var statusBarHeight: CGFloat { return UIApplication.shared.statusBarFrame.height }
}

extension UILabel {
    convenience init(frame: CGRect = .zero, text: String = "", textColor: UIColor, font: UIFont, backgroundColor: UIColor = .clear) {
        self.init(frame: frame)
        self.text = text
        self.textColor = textColor
        self.font = font
        self.backgroundColor = backgroundColor
    }
    convenience init(frame: CGRect = .zero, attributedText: String, textColor: UIColor, font: UIFont, lineSpacing: CGFloat) {
        self.init(frame: frame)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineBreakMode = .byTruncatingTail
        let attrStr = NSAttributedString(string: attributedText, attributes: [NSParagraphStyleAttributeName: paragraphStyle,
                                                                              NSFontAttributeName: font,
                                                                              NSForegroundColorAttributeName: textColor])
        self.attributedText = attrStr
    }
}

extension UIButton {
    convenience init(frame: CGRect = .zero, text: String = "", textColor: UIColor, font: UIFont) {
        self.init(frame: frame)
        self.titleLabel?.font = font
        self.setTitle(text, for: .normal)
        self.setTitleColor(textColor, for: .normal)
    }
}

extension String {

    ///根据路径得到文件的大小
    var fileSizeByPath: Double {
        guard FileManager.default.fileExists(atPath: self) else {
            print("该\(self)路径下文件不存在")
            return 0.0
        }
        guard let attr = try? FileManager.default.attributesOfItem(atPath: self),
            let size = attr[.size] as? Double
            else { return 0.0 }
        return size
    }
}

extension URL {
    
    /// 从URL中获取七牛key 格式: video_1489682068416
    var videoKey: String? {
        
        let range = absoluteString.range(of: "video_\\d{13}", options: .regularExpression)
        if let range = range {
            return absoluteString.substring(with: range)
        }else{
            return nil
        }
    }
    /// 从URL中获取七牛key 格式: image_1489682068416
    var imageKey: String? {
        
        let range = absoluteString.range(of: "image_\\d{13}", options: .regularExpression)
        if let range = range {
            return absoluteString.substring(with: range)
        }else{
            return nil
        }
    }

    // http://omf96dac8.bkt.clouddn.com/video_1489742031313?e=1489896566&token=M0d41YInGzEh_TCmfrGqQaufEa8etVQOIGUD0uNR:rxhrfl0ZAAzbS-pwKcwhwKJ8nVs=
    /// URL转变成唯一的缓存key: 截取❓前面的
    var cacheKey: String? {
        return (scheme ?? "") + "://" + (host ?? "") + path
    }
    
    /// 转化成 Resource?
    var safeResource: Resource? {
        return ImageResource(downloadURL: self, cacheKey: cacheKey ?? absoluteString)
    }
}

extension UIView {
    /// 添加阴影
    func layerAddShadow() {
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 4
    }
    /// 添加渐变
    func grandient(angle: Double = 0,
                   colors: [UIColor]    = [.gradientBeginColor, .gradientEndColor],
                   locations: [NSNumber]  = [0, 1])
    {
        //FIXME: 防止重复添加
        if (layer.sublayers ?? []).contains(where: { $0 is CAGradientLayer }) { return }
        
        let offset = tan(angle * M_PI / 180) / 2
        let gl = CAGradientLayer()
        gl.frame = bounds
        layer.insertSublayer(gl, at: 0)
        gl.colors = colors.map{ $0.cgColor }
        gl.startPoint = CGPoint(x: 0, y: 0.5 + offset)
        gl.endPoint = CGPoint(x: 1, y: 0.5 - offset)
        gl.locations = locations
    }
}

// MARK: - 系统小菊花
extension UIView {

    private struct ActivityViewKey {
        static var activity = "Activity"
    }

    func showSystemActivityLoading() {
        
        if let _ = objc_getAssociatedObject(self, &ActivityViewKey.activity) as? UIActivityIndicatorView {
            return
        }
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityView)
        
        addConstraint(NSLayoutConstraint(item: activityView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: activityView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        activityView.startAnimating()
        objc_setAssociatedObject(self, &ActivityViewKey.activity, activityView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func hideSystemActivityLoading() {
        if let activityView = objc_getAssociatedObject(self, &ActivityViewKey.activity) as? UIActivityIndicatorView {
            activityView.stopAnimating()
            activityView.removeFromSuperview()
            objc_setAssociatedObject(self, &ActivityViewKey.activity, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}



func + <Key: Hashable, Value>(lfs: [Key: Value], rfs: [Key: Value]) -> [Key: Value] {
    var temp = lfs
    rfs.forEach{ key, value in temp[key] = value }
    return temp
}

//MARK: UIImage size
extension UIImage {
    func compressTo(targetWidth: CGFloat) -> UIImage {
        let imageSize = self.size
        
        let width = imageSize.width
        let height = imageSize.height
        
        let targetHeight = (targetWidth / width) * height
        
        UIGraphicsBeginImageContext(CGSize(width: targetWidth, height: targetHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension Array {
    func subArray(page: Int, pageSize: Int = 3) -> Array {
        
        guard count > 0 else {
            return self
        }
        
        let remainder = count % pageSize
        let hasRemainder = remainder != 0
        let totalPage = count / pageSize + (hasRemainder ? 1 : 0)
        
        let truePage = page % totalPage
        let isLastPage = (truePage == totalPage - 1) && remainder != 0
        let trueSize = isLastPage ? remainder : pageSize
        let startIndex = truePage * pageSize
        
        return Array(self[startIndex..<(startIndex + trueSize)])
    }
}

extension UIView {

    var belongViewController: UIViewController? {
        var vc: UIViewController?
        var next = self.next
        while next != nil {
            if next!.isKind(of: UIViewController.self) {
                vc = (next! as! UIViewController)
                break
            }
            next = next?.next
        }
        return vc
    }
}

extension UIViewController {

    var topPresentingViewController: UIViewController? {
       
        guard let fVc = self.presentingViewController else {
            return nil
        }
        var eVc = fVc
        while true {
            if eVc.presentingViewController == nil {
                return eVc
            }
            eVc = eVc.presentingViewController!
        }
    }
}

extension TimeInterval {
    
    var weekDay: String {
        let days = ["" ,"周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        let date = Date(timeIntervalSince1970: self)
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.component(.weekday, from: date)
        return days[components]
    }
    
    var weekDayAndTime: String {        
        return "\(weekDay) \(lp.formatTime(format: "HH:mm"))"
    }
}

extension UITableViewCell {
    func setSelectedBackgroundView() {
        let backView = UIView()
        backView.backgroundColor = UIColor.popupBGColor_3F434C
        selectedBackgroundView = backView
    }
}


extension Int {
    var moneyString: String {
        let result = formaterMoney(self)
        return result
    }
    
    private func formaterMoney(_ int: Int) -> String {
        let other = int / 1000
        if other == 0 {
            return int.description
        } else{
            return formaterMoney(other) + "," + int.description.lastString(3)
        }
    }
}

extension String {
    var moneyValue: String? {
        get {
            return Int(self)?.moneyString
        }
    }
    
    func lastString(_ index: Int) -> String {
        if index > self.characters.count { return "" }
        return self.substring(from: self.index(self.endIndex, offsetBy: -index))
    }
    
    var isAvailableNickName: Bool {
        return !(replacingOccurrences(of: " ", with: "").isEmpty)
    }
    /// 添加阴影
    func toShadow(shadowColor: UIColor = .black,
                  blurRadius: CGFloat = 5.0,
                  offset: CGSize = CGSize(width: 5, height: 5)) -> NSMutableAttributedString {
        
        let shadow = NSShadow()
        shadow.shadowColor = shadowColor
        shadow.shadowBlurRadius = blurRadius
        shadow.shadowOffset = offset
        return NSMutableAttributedString(string: self, attributes: [NSShadowAttributeName: shadow])
    }
}
