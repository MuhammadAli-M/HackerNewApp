//
//  StoryWebsiteController.swift
//  HackerNews
//
//  Created by Muhammad Adam on 2/17/19.
//  Copyright © 2019 Muhammad Adam. All rights reserved.
//

import UIKit
import WebKit

/// The single story's website controller
class StoryWebsiteController: UIViewController{

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    var urlString:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTextField.text = urlString
        webView.navigationDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
        
        let url:URL = URL(string: urlString)!
        let urlRequest:URLRequest = URLRequest(url: url)
        webView.load(urlRequest)
        webView.allowsBackForwardNavigationGestures = true
        urlTextField.text = urlString
    }

    @IBAction func clickBackbutton(_ sender: Any) {
        if webView.canGoBack{
            webView.goBack()
            urlTextField.text = webView.url?.absoluteString
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func clickForwardButton(_ sender: Any) {
        if webView.canGoForward{
            webView.goForward()
            urlTextField.text = webView.url?.absoluteString
        }
    }
    
}

// MARK: - WebKit Naviagation Delegate
extension StoryWebsiteController: WKNavigationDelegate{
    
    /// Updates UI to reflect the new website's info.
    ///
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        forwardButton.isEnabled = webView.canGoForward
        urlTextField.text = webView.url?.absoluteString
    }
}
