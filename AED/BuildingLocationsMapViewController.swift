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
    var userLastLocationCoordinate2D: CLLocationCoordinate2D?
    var availableBuildings = [String:BuildingModel]()
    var sortedBuildingList: [BuildingModel]?
    let MAX_NO_OF_BUILDINGS_TO_DISPLAY = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.cloudAPI = AMapCloudAPI(cloudKey:ConfigurationConstants.AMAP_CLOUD_MAP_API_KEY, delegate:nil)
        self.cloudAPI?.delegate = self;
        initMapView()
        refreshAEDList()
    }
    
    func sortBuildingList() {
        //print("Sorting Building List")
        sortedBuildingList = [BuildingModel]()
        for (_, building) in availableBuildings {
            sortedBuildingList!.append(building)
        }
        
        sortedBuildingList!.sortInPlace({$0.distance < $1.distance})
    }
    
    func refreshAEDList() {
        //print("Refreshing AED list with coordinate \(userLastLocationCoordinate2D)")
        if userLastLocationCoordinate2D == nil {
            //print("cannot refresh aed list because user last location is nil")
            return
        }
        
        
        let latitude = Double(userLastLocationCoordinate2D!.latitude)
        let longitude = Double(userLastLocationCoordinate2D!.longitude)
        let centerPoint =  AMapCloudPoint.locationWithLatitude(CGFloat(latitude), longitude: CGFloat(longitude))
        
        let placeAroundRequest =  AMapCloudPlaceAroundSearchRequest()
        placeAroundRequest.tableID = ConfigurationConstants.AMAP_CLOUD_MAP_TABLE_ID
        placeAroundRequest.radius = ConfigurationConstants.AMAP_CLOUD_MAP_SEARCH_RADIUS_IN_METER
        placeAroundRequest.center = centerPoint
        placeAroundRequest.offset = 20
        
        self.cloudAPI!.AMapCloudPlaceAroundSearch(placeAroundRequest)
    }
    
    func mapView(mapView: MAMapView!, didUpdateUserLocation userLocation: MAUserLocation!, updatingLocation: Bool) {
        if (updatingLocation && isNewCoordinate(userLocation.coordinate)) || sortedBuildingList == nil || sortedBuildingList!.isEmpty {
            refreshAEDList()
        } else {
            //print("Cannot refresh AEDList because")
            //print("Last coordinate is: \(userLastLocationCoordinate2D) and new coordinate is: \(userLocation.coordinate)")
        }
    }
    
    func isNewCoordinate(coordinate: CLLocationCoordinate2D?) -> Bool {
        if coordinate == nil {
            return false
        }
        
        if userLastLocationCoordinate2D == nil {
            userLastLocationCoordinate2D = coordinate
            return true
        }
        
        if userLastLocationCoordinate2D?.latitude != coordinate!.latitude || userLastLocationCoordinate2D?.longitude != coordinate!.longitude {
            userLastLocationCoordinate2D = coordinate
            return true
        }
        
        return false
    }
        
    func initMapView() {
        MAMapServices.sharedServices().apiKey = ConfigurationConstants.AMAP_CLOUD_MAP_API_KEY
        mapView = MAMapView(frame: self.view.frame)
        mapView!.delegate = self
        self.view.addSubview(mapView!)
        
        mapView!.desiredAccuracy = kCLLocationAccuracyBest
        mapView!.setUserTrackingMode(MAUserTrackingMode.FollowWithHeading, animated: true)
        mapView!.showsCompass = false
        mapView!.showsScale = false
        

        mapView!.zoomEnabled = true
        mapView!.showsUserLocation = true
        userLastLocationCoordinate2D = nil
        print(mapView!.getMapStatus())
    }
    

    
    func onCloudPlaceAroundSearchDone(request:AMapCloudPlaceAroundSearchRequest, response:AMapCloudSearchResponse)
    {
        //print("Found \(response.count) AEDs")
        updateAvailableBuildings(response.POIs as! [AMapCloudPOI])
        zoomToFitMapAnnotations()
    }

    func cloudRequest(cloudSearchRequest: AnyObject!, error: NSError!) {
        print(error.localizedDescription)
        let alert = UIAlertController(title: "", message: "请求失败！原因：\(error.localizedDescription) 请拨打120急救！", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func mapView(mapView:MAMapView, viewForAnnotation annotation:MAAnnotation) ->MAAnnotationView? {

        if annotation.isKindOfClass(CustomAnnotation) {
            let annotationIdentifier = "aedBuildingIdentifier"
            
            var poiAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier) as? AEDBuildingAnnotationView
            
            if poiAnnotationView == nil {
                poiAnnotationView = AEDBuildingAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            }
            
            //poiAnnotationView!.canShowCallout = true
            //poiAnnotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
            
            return poiAnnotationView;
        }
        return nil
    }
    
    func mapView(mapView: MAMapView!, annotationView view: MAAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        performSegueWithIdentifier("ShowBuildingInfoSegue", sender: view)
    }
    

    
    func zoomToFitMapAnnotations() {
        if mapView!.annotations.count == 0 {
            return
        }
        
        var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        
        var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)

        for index in 0...MAX_NO_OF_BUILDINGS_TO_DISPLAY {
            let coordinate = sortedBuildingList![index].coordinate
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, coordinate.longitude)
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, coordinate.latitude)
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, coordinate.longitude)
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, coordinate.latitude)
        }
        
        let annotation = mapView!.userLocation
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude)
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude)
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude)
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude)
        
        var region = MACoordinateRegion()
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.2
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.2
        
        mapView!.setRegion(region, animated: false)
    }
    func updateAvailableBuildings(pois: [AMapCloudPOI]) {
        availableBuildings = [String:BuildingModel]()

        for poi in pois {
            let customFields = poi.customFields
            let buildingID = customFields["buildingID"] as! String
            var building: BuildingModel
            if availableBuildings[buildingID] == nil {
                building = BuildingModel()
                building.name = poi.name
                building.address = poi.address
                building.distance = poi.distance
                building.coordinate = CLLocationCoordinate2DMake(Double(poi.location.latitude), Double(poi.location.longitude))
                building.buildingID = buildingID
            } else {
                building = availableBuildings[buildingID]!
            }
            
            let aed = AEDModel()
            aed.floor = customFields["floor"] as? String
            aed.specificLocation = customFields["location"] as? String
            aed.directionToFind = customFields["directionToFind"] as? String
            aed.building = building
            building.aeds.append(aed)
            
            availableBuildings[buildingID] = building
        }
 
        sortBuildingList()
        var index = 0
        var firstAnnotation : CustomAnnotation?
        for building in sortedBuildingList! {
            let annotation = CustomAnnotation()
            annotation.coordinate = building.coordinate
            annotation.title = "\(index). \(building.name)"
            annotation.subtitle = "\(building.aeds.count)台(\(building.distance)m)"
            annotation.customProperties["building"] = building
            annotation.sequenceNumber = index
 
            mapView!.addAnnotation(annotation)
            
            if index == 0 {
                firstAnnotation = annotation
            }
            
            index += 1
        }
        
        mapView!.selectAnnotation(firstAnnotation, animated: false)
    }
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowBuildingInfoSegue" {
            let aedDetailViewController = segue.destinationViewController as! BuildingInfoViewController
            let selectedAnnotationView = sender as! AEDBuildingAnnotationView
            let building = selectedAnnotationView.customProperties!["building"]
            aedDetailViewController.building = building as! BuildingModel
        }
    }
}
