//
//  CPRDirectionViewController.swift
//  AED
//
//  Created by Yang Yu on 10/19/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit
import WebKit

class CPRDirectionViewController: UIViewController {
    
    // MARK: Properties
    
    var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = true
        loadCPRDirectionLocally()
    }
    
    func loadCPRDirectionLocally() {
        webView = WKWebView(frame: CGRectMake(0, self.navigationController!.navigationBar.frame.height, self.view.frame.width, self.view.frame.height - self.navigationController!.navigationBar.frame.height - self.tabBarController!.tabBar.frame.height))
        
        var filePath = NSBundle.mainBundle().pathForResource("HowToCPR", ofType: "html")
        let url = NSURL(fileURLWithPath: filePath!)
        let request = NSURLRequest(URL: url)
    
        webView!.loadRequest(request)
        
        self.view.addSubview(webView!)
    }
}
