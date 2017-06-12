//
//  BaseWebViewController.swift
//  CarLoan
//
//  Created by 郜宇 on 2016/11/30.
//  Copyright © 2016年 Loopeer. All rights reserved.
//

import UIKit
import WebKit
import LPNetworkManager
import SwiftyJSON

fileprivate let baseURL = URL.init(string: baseURLString)!

enum KeyType: String {
    ///服务协议及隐私政策
    case `Protocol` = "Protocol"
    case FAQ
}

class BaseWebViewController: BaseViewController {
    
    fileprivate lazy var webView: UIWebView = {
        let web = UIWebView(frame: CGRect(x: 0, y: 64, width: .screenWidth, height: .screenHeight - 64))
        return web
    }()
    fileprivate var loadingView: UIActivityIndicatorView!
    
    fileprivate var type: KeyType
    
    init(type: KeyType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavigationBarView()
        webView.delegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.backgroundColor = .backgroundColor
        view.addSubview(webView)
    
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        loadingView.center = self.view.center
        webView.addSubview(loadingView)
        
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        if let url = URL(string: baseURLString + "/api/v1/system/document/" + "\(type.rawValue)"){
            let request = URLRequest(url: url)
            webView.loadRequest(request)
            loadingView.startAnimating()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BaseWebViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadingView.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        loadingView.stopAnimating()
    }
}

