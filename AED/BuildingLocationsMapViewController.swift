//
//  BuildingLocationsMapViewController.swift
//  AED
//
//  Created by Yang Yu on 10/12/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit

class BuildingLocationsMapViewController: UIViewController, MAMapViewDelegate, AMapCloudDelegate {

    var cloudAPI : AMapCloudAPI?
    var mapView: MAMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMapView()
        
        mapView?.showsUserLocation = true
        mapView?.setUserTrackingMode(MAUserTrackingMode.Follow, animated: true)
        mapView?.showsScale = true
        
        
        
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
    func mapView(mapView: MAMapView!, didUpdateUserLocation userLocation: MAUserLocation!, updatingLocation: Bool) {
        print("hello")
        print(updatingLocation)
        print(userLocation.coordinate.longitude)
        print(userLocation.coordinate.latitude)
    }
    func initMapView() {
        MAMapServices.sharedServices().apiKey = ConfigurationConstants.AMAP_CLOUD_MAP_API_KEY
        mapView = MAMapView(frame: self.view.bounds)
        mapView!.delegate = self
        self.view.addSubview(mapView!)
        self.view.sendSubviewToBack(mapView!)
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
