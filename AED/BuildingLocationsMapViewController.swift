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
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMapView()
        
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
        if updatingLocation {
            currentLocation = userLocation.location
        }
    }
    func initMapView() {
        MAMapServices.sharedServices().apiKey = ConfigurationConstants.AMAP_CLOUD_MAP_API_KEY
        mapView = MAMapView(frame: self.view.bounds)
        mapView!.delegate = self
        self.view.addSubview(mapView!)
       // self.view.sendSubviewToBack(mapView!)
        
        mapView!.showsUserLocation = true
        mapView!.setUserTrackingMode(MAUserTrackingMode.Follow, animated: true)
        mapView!.showsScale = true
        
        let compassX = mapView?.compassOrigin.x
        
        let scaleX = mapView?.scaleOrigin.x
        
        //设置指南针和比例尺的位置
        mapView?.compassOrigin = CGPointMake(compassX!, 21)
        
        mapView?.scaleOrigin = CGPointMake(scaleX!, 21)
        
        mapView!.setZoomLevel(15.1, animated: true)
    }
    

    
    func onCloudPlaceAroundSearchDone(request:AMapCloudPlaceAroundSearchRequest, response:AMapCloudSearchResponse)
    {
        print("hello world")
        print(response.count)
        for poi in response.POIs as! [AMapCloudPOI]{
            print(poi.distance)
            
            let annotation = MAPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(Double(poi.location.latitude), Double(poi.location.longitude))
            annotation.title = poi.name
            annotation.subtitle = "1台(\(poi.distance)m)"
            mapView!.addAnnotation(annotation)
        }
    }

    func cloudRequest(cloudSearchRequest: AnyObject!, error: NSError!) {
        print("error")
    }
    
    func mapView(mapView:MAMapView, viewForAnnotation annotation:MAAnnotation) ->MAAnnotationView? {
        print("hello annotation view")
        if annotation.isKindOfClass(MAPointAnnotation) {
            let annotationIdentifier = "aedBuildingIdentifier"
            
            var poiAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier) as? MAPinAnnotationView
            
            if poiAnnotationView == nil {
                poiAnnotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            }
            
            
            poiAnnotationView?.image = UIImage(named: "aedIcon")
            poiAnnotationView!.animatesDrop   = true
            poiAnnotationView!.canShowCallout = true
            
            return poiAnnotationView;
        }
        return nil
    }
}
