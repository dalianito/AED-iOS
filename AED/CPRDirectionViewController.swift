//
//  CPRDirectionViewController.swift
//  AED
//
//  Created by Yang Yu on 10/19/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit

class CPRDirectionViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCPRDirectionLocally()
    }
    
    func loadCPRDirectionLocally() {
        let url = NSBundle.mainBundle().URLForResource("HowToCPR", withExtension:"html")
        let requestObj = NSURLRequest(URL: url!)
        webView.loadRequest(requestObj)
    }

}
