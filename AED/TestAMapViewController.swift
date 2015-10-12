//
//  TestAMapViewController.swift
//  AED
//
//  Created by Yang Yu on 10/12/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit

class TestAMapViewController: UIViewController, AMapCloudDelegate {

    var cloudAPI : AMapCloudAPI?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let placeAround =  AMapCloudPlaceAroundSearchRequest()
        placeAround.tableID = ConfigurationConstants.AMAP_CLOUD_MAP_TABLE_ID
        let radius =  5000
        let centerPoint =  AMapCloudPoint.locationWithLatitude(38.926, longitude:121.66)
        placeAround.radius = radius
        placeAround.center = centerPoint
        placeAround.keywords = ""
        placeAround.offset = 10
        

        self.cloudAPI = AMapCloudAPI(cloudKey:ConfigurationConstants.AMAP_CLOUD_MAP_API_KEY, delegate:nil)
        self.cloudAPI?.delegate = self;
        self.cloudAPI!.AMapCloudPlaceAroundSearch(placeAround)
        
    }
    
    func onCloudPlaceAroundSearchDone(request:AMapCloudPlaceAroundSearchRequest, response:AMapCloudSearchResponse)
    {
        print("hello world")
        print(response.count)
        for poi in response.POIs as! [AMapCloudPOI]{
            print(poi.distance)
        }
    }

    func cloudRequest(cloudSearchRequest: AnyObject!, error: NSError!) {
        print("error")
    }
}
