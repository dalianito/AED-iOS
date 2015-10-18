//
//  BottomTabBarController.swift
//  AED
//
//  Created by Yang Yu on 10/16/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit

class BottomTabBarController: UITabBarController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        addMayDayButton()
    }

    
    func addMayDayButton() {
        let mayDayButtonWidth = self.tabBar.frame.size.width / 5
        let mayDayButtonHeight = self.tabBar.frame.size.height
        let mayDayButton = UIButton(frame:CGRect(origin: CGPointMake(mayDayButtonWidth * 2, 0), size:CGSizeMake(mayDayButtonWidth, mayDayButtonHeight)))
        mayDayButton.backgroundColor = UIColor.redColor()
        mayDayButton.setTitle("120", forState: UIControlState.Normal)
        mayDayButton.addTarget(self, action: "onMayDayButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.tabBar.addSubview(mayDayButton)
    }
    
    func onMayDayButtonPressed() {
        let alert = UIAlertController(title: "", message: "拨打\(ConfigurationConstants.EMERGENCY_CENTER_PHONE_NUMBER)急救么？", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "现在拨打!", style: UIAlertActionStyle.Default, handler: {
            (alerts: UIAlertAction!) in
            self.callEmergencyCenter()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func callEmergencyCenter() {
        print("hello")
        let phoneUrl = NSURL(string: "tel:120")
        if UIApplication.sharedApplication().canOpenURL(phoneUrl!) {
            UIApplication.sharedApplication().openURL(phoneUrl!)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
