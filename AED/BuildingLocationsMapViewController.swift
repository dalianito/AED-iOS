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
        mapView = MAMapView(frame: self.view.frame)
        mapView!.delegate = self
        self.view.addSubview(mapView!)
        
        mapView!.desiredAccuracy = kCLLocationAccuracyBest
        mapView!.setUserTrackingMode(MAUserTrackingMode.Follow, animated: true)
        mapView!.showsCompass = true
        mapView!.showsScale = true
        
        
        let compassX = mapView?.compassOrigin.x
        
        let scaleX = mapView?.scaleOrigin.x
        
        //设置指南针和比例尺的位置
        mapView?.compassOrigin = CGPointMake(compassX!, 21)
        
        mapView?.scaleOrigin = CGPointMake(scaleX!, 21)
        
        mapView!.zoomLevel = 10
        
        mapView!.zoomEnabled = true
        
        mapView!.showsUserLocation = true
        print("zoom level")
        print(mapView!.zoomLevel)
    }
    

    
    func onCloudPlaceAroundSearchDone(request:AMapCloudPlaceAroundSearchRequest, response:AMapCloudSearchResponse)
    {
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
        print(error.localizedDescription)
        let alert = UIAlertController(title: "", message: "请求失败！原因：\(error.localizedDescription) 请拨打120急救！", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func mapView(mapView:MAMapView, viewForAnnotation annotation:MAAnnotation) ->MAAnnotationView? {

        if annotation.isKindOfClass(MAPointAnnotation) {
            let annotationIdentifier = "aedBuildingIdentifier"
            
            var poiAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier) as? MAPinAnnotationView
            
            if poiAnnotationView == nil {
                poiAnnotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            }
            
            poiAnnotationView!.animatesDrop   = true
            poiAnnotationView!.canShowCallout = true
            poiAnnotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
            
            return poiAnnotationView;
        }
        return nil
    }
    
    func mapView(mapView: MAMapView!, annotationView view: MAAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        performSegueWithIdentifier("test", sender: control)
    }
    

    
    func zoomToFitMapAnnotations() {
        if mapView!.annotations.count == 0 {
            return
        }
        
        var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        
        var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)

        for annotation in mapView!.annotations as! [MAAnnotation] {
            if annotation.isKindOfClass(MAUserLocation) {
                continue
            }
            
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude)
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude)
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude)
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude)
        }
        
        var region = MACoordinateRegion()
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.2
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.2
        
        mapView!.setRegion(region, animated: true)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepare for segue")
    }
}
