//
//  ShareInviteViewController.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/4/11.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit
import LPExtensions

class ShareInviteViewController: BaseViewController {
    
    var type: ShareInviteTpye = .share
    fileprivate var dataSource: ShareInviteViewModel!
    
    fileprivate let logoView = UIImageView(image: #imageLiteral(resourceName: "logo"))
    fileprivate var titleLabel: UILabel!
    fileprivate var collectionView: UICollectionView!
    fileprivate var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = ShareInviteViewModel(type: type)
        setupUI()
    }
}

extension ShareInviteViewController {
    func setupUI() {
        
        
        titleLabel = UILabel(attributedText: dataSource.title, textColor: dataSource.titleColor, font: dataSource.titleFont, lineSpacing: 8)
        titleLabel.numberOfLines = 0
        
        titleLabel.textAlignment = .center
        
        let layout = FlowLayout()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .backgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        
        closeButton = UIButton(type: .custom)
        closeButton.setBackgroundImage(#imageLiteral(resourceName: "share_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        view.addSubview(logoView)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(closeButton)
    
        collectionView.register(ShareCell.self, forCellWithReuseIdentifier: ShareCell.description())

        
        let platformType = UIDevice.current.lp.platformType()
        
        logoView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(88.adapt)
            make.width.height.equalTo(70)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(logoView.snp.bottom).offset(28.adapt)
            make.centerX.equalToSuperview()
        }
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.top.equalTo(logoView.snp.bottom).offset(platformType == .iPhone4S ? 100.adapt : 135.adapt)
            make.height.equalTo(155)
        }
        closeButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(platformType == .iPhone4S ? 10.adapt : 80.adapt)
            make.width.height.equalTo(54)
        }
    }
    
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func share(with platformType: UMSocialPlatformType) {
        Social.share(platformType: platformType, controller: self, successHandler: { (type) in
            _ = self.navigationController?.popViewController(animated: true)
        }) { (error) in
            if error.localizedDescription.contains("2008") {
                showToast(String(key: .shareFailedToast))
            }
        }
    }
}

extension ShareInviteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShareCell.description(), for: indexPath) as? ShareCell else { return ShareCell() }
        cell.update(model: dataSource.cellModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // +1 临时去掉微博分享等审核通过
        switch indexPath.row + 1{
        case 0:
            //新浪微博
            share(with: .sina)
            MDAnalyticsTool.log(event: .sinaClick)
        case 1:
            //微信好友
            share(with: .wechatSession)
            MDAnalyticsTool.log(event: .weChatClick)
        case 2:
            //朋友圈
            share(with: .wechatTimeLine)
            MDAnalyticsTool.log(event: .momentsClick)
        case 3:
            //QQ好友
            share(with: .QQ)
            MDAnalyticsTool.log(event: .qqClick)
        case 4:
            //QQ空间
            share(with: .qzone)
            MDAnalyticsTool.log(event: .qzoneClick)
        case 5:
            //复制链接
            UIPasteboard.general.string = Social.sharedURL
            showToast(String(key: .copyLinkToast))
            MDAnalyticsTool.log(event: .copyLinkClink)
        default:
            break
        }
    }
}

class FlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attrs = super.layoutAttributesForElements(in: rect)
        var newAttrs = [UICollectionViewLayoutAttributes]()
        let w = CGFloat(52)
        let h = CGFloat(55.0)
        let marge = (.screenWidth - 100.0 - 3.0 * w) * 0.5
        
        for(i, attr) in (attrs ?? []).enumerated() {

            let x = (w + marge) * CGFloat(i % 3)
            let y = (h + 44) * CGFloat(i / 3)
            attr.frame = CGRect(x: x, y: y, width: w, height: h)
            newAttrs.append(attr)
        }
        return newAttrs
    }
}


