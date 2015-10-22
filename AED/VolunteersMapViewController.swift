//
//  VolunteersMapViewController.swift
//  AED
//
//  Created by Yang Yu on 10/21/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit

class VolunteersMapViewController: UIViewController, MAMapViewDelegate, AMapCloudDelegate {

    var mapView: ITOMapView?
    var locationButton: UIButton?
    var callForHelpButton: UIButton?
    
    let SEARCHING_INDICATOR_MSG = "正在搜索附近\(ConfigurationConstants.AMAP_CLOUD_MAP_SEARCH_RADIUS_IN_METER/1000)公里内志愿者..."
    
    override func viewDidLoad() {
        initMapView()
        initCallForHelpButton()
    }

    func initMapView() {
        MAMapServices.sharedServices().apiKey = ConfigurationConstants.AMAP_CLOUD_MAP_API_KEY
        mapView = ITOMapView(frame: self.view.frame)
        mapView!.delegate = self
        self.view.addSubview(mapView!)
        
        
        locationButton = UIButton(frame: CGRectMake(10, self.tabBarController!.tabBar.frame.origin.y - 50, 40, 40))
        locationButton!.autoresizingMask = [UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleTopMargin]
        locationButton!.layer.cornerRadius = 10
        
        locationButton!.addTarget(self, action: "requestNewUserLocation:", forControlEvents: UIControlEvents.TouchUpInside)
        
        locationButton!.setImage(UIImage(named: "location_yes"), forState: UIControlState.Normal)
        
        self.view.addSubview(locationButton!)
    }
    
    func initCallForHelpButton() {
        callForHelpButton = UIButton(frame: CGRectMake(80, self.tabBarController!.tabBar.frame.origin.y - 60, self.view.frame.size.width - 80*2, 50))
        callForHelpButton!.autoresizingMask = [UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleTopMargin]
        callForHelpButton!.layer.cornerRadius = 10
        callForHelpButton!.setTitle("呼叫志愿者", forState: UIControlState.Normal)
        callForHelpButton!.backgroundColor = UIColor.redColor()
        callForHelpButton!.titleLabel!.textColor = UIColor.whiteColor()
        callForHelpButton!.titleLabel!.font = UIFont.boldSystemFontOfSize(20)
        
        callForHelpButton!.addTarget(self, action: "callForHelp:", forControlEvents: UIControlEvents.TouchUpInside)

        self.view.addSubview(callForHelpButton!)
    }
    
    func callForHelp(sender: UIButton) {
        print("The callForHelp action in VolunteersMapViewController hasn't been implemented yet")
        
    }
    
    func requestNewUserLocation(sender: UIButton) {
        print("The requestNewUserLocation actin in VolunteersMapViewController hasn't been implemented yet")
        
    }
    
}
