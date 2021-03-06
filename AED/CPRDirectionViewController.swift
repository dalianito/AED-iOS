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
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = true
        loadCPRDirectionLocally()
    }
    
    func loadCPRDirectionLocally() {
        let filePath = NSBundle.mainBundle().pathForResource("HowToCPR", ofType: "html")
        let url = NSURL(fileURLWithPath: filePath!)
        let request = NSURLRequest(URL: url)
    
        webView!.loadRequest(request)
        
        self.view.addSubview(webView!)
    }
}
