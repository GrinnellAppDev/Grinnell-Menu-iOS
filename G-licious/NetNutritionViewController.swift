//
//  NetNutritionViewController.swift
//  G-licious
//
//  Created by AppDev on 1/25/16.
//  Copyright © 2016 Maijid Moujaled. All rights reserved.
//

import UIKit
import WebKit

class NetNutritionViewController: UIViewController, WKNavigationDelegate {

    private let NET_NUTRITION_URL = NSURL(string: "http://nutrition.grinnell.edu/NetNutrition/1/Mobile/Mobile")!
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize / configure the webView
        
        webView = WKWebView()
        webView.navigationDelegate = self
        
        // Push the webview down 20 pts so status bar is visible
        webView.frame = CGRectMake(0, 20, view.frame.width, view.frame.height - 20)
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        view.layoutIfNeeded()
        
        webView.loadRequest(NSURLRequest(URL: NET_NUTRITION_URL))
    }
    
    // Logging for debugging
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        NSLog("Failed provisional navigation: %@", error.userInfo);
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        NSLog("Failed navigation: %@", error.userInfo);
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        NSLog("Finished navigation")
    }
    
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        NSLog("Committed navigation")
    }
}
