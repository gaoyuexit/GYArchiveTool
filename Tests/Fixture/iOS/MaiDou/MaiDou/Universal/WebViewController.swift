//
//  WebViewController.swift
//  Marukoya
//
//  Created by Guo Zhiqiang on 16/8/31.
//  Copyright © 2016年 Loopeer. All rights reserved.
//

import UIKit


class WebViewController: BaseViewController {
    var webView: UIWebView!
    var loadingView: UIActivityIndicatorView!
    
    var url: URL?
    var htmlContent: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        if let URL = url {
            webView.loadRequest(URLRequest(url: URL))
            loadingView.startAnimating()
        } else if let htmlContent = htmlContent {
            webView.loadHTMLString(htmlContent, baseURL: nil)
            loadingView.startAnimating()
        }
    }
    
    func setupUI() {
        showNavigationBarView()
        
        webView = UIWebView(frame: view.bounds)
        webView.delegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(webView)
        
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        loadingView.center = self.view.center
        webView.addSubview(loadingView)
    }
}

extension WebViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadingView.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        loadingView.stopAnimating()
    }
}
