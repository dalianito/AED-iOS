//
//  BuildingLocationsMapViewController.swift
//  AED
//
//  Created by Yang Yu on 10/12/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit

class BuildingLocationsMapViewController: UIViewController, MAMapViewDelegate, AMapCloudDelegate, UIScrollViewDelegate {

    var cloudAPI : AMapCloudAPI?
    var mapView: MAMapView?
    var userLastLocationCoordinate2D: CLLocationCoordinate2D?
    var availableBuildings = [String:BuildingModel]()
    var sortedBuildingList: [BuildingModel]?
    let MAX_NO_OF_BUILDINGS_TO_DISPLAY = 3
    var locationButton: UIButton?
    var uiScrollView: UIScrollView?
    var uiScrollViewCurrentPage: NSInteger?
    var isSearching = true
    var alert: UIAlertView?
    
    let SEARCHING_INDICATOR_MSG = "正在搜索附近3公里内可用的AED仪器..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.cloudAPI = AMapCloudAPI(cloudKey:ConfigurationConstants.AMAP_CLOUD_MAP_API_KEY, delegate:nil)
        self.cloudAPI?.delegate = self;
        initMapView()
        initScrollView()
        showLoadingIndicatorWithMessage(SEARCHING_INDICATOR_MSG)
        
        refreshAEDList()
    }
    
    func showLoadingIndicatorWithMessage(message: String) {
        alert = UIAlertView(title: nil, message: message, delegate: self, cancelButtonTitle: "取消")
        let activityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 60, 60))
        activityIndicatorView.center = self.view.center
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        alert!.setValue(activityIndicatorView, forKey: "accessoryView")
        activityIndicatorView.startAnimating()
        alert!.show()
    }
    func initScrollView() {
        let tabBarItemWidth = self.tabBarController!.tabBar.frame.size.width / 5
        let tabBarHeight = self.tabBarController!.tabBar.frame.size.height
        let tabBarLocY = self.tabBarController!.tabBar.frame.origin.y
        self.uiScrollView = UIScrollView(frame: CGRect(origin: CGPointMake(tabBarItemWidth, tabBarLocY - tabBarHeight-10), size:CGSizeMake(tabBarItemWidth*3, tabBarHeight)))
        self.uiScrollView!.delegate = self
        
        self.view.addSubview(self.uiScrollView!)
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.uiScrollView!.bounces = false
        self.uiScrollView!.pagingEnabled = true
        self.uiScrollView!.showsHorizontalScrollIndicator = false
        self.uiScrollView!.showsVerticalScrollIndicator = false
    }
    
    func sortBuildingList() {
        sortedBuildingList = [BuildingModel]()
        for (_, building) in availableBuildings {
            sortedBuildingList!.append(building)
        }
        
        sortedBuildingList!.sortInPlace({$0.distance < $1.distance})
    }
    
    func refreshAEDList() {
        if userLastLocationCoordinate2D == nil {
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
        if isSearching == false {
            return
        }
        
        if (updatingLocation && isNewCoordinate(userLocation.coordinate)) || sortedBuildingList == nil || sortedBuildingList!.isEmpty{
            refreshAEDList()
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
        mapView!.showsUserLocation = true
        
        mapView!.setUserTrackingMode(MAUserTrackingMode.FollowWithHeading, animated: true)
        mapView!.desiredAccuracy = kCLLocationAccuracyBest
        mapView!.distanceFilter = ConfigurationConstants.AMAP_DISTANCE_FILTER_IN_METER
        mapView!.showsCompass = false
        mapView!.showsScale = false
        mapView!.zoomEnabled = true
        
        userLastLocationCoordinate2D = nil
        
        locationButton = UIButton(frame: CGRectMake(10, self.tabBarController!.tabBar.frame.origin.y - 50, 40, 40))
        locationButton!.autoresizingMask = [UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleTopMargin]
        locationButton!.layer.cornerRadius = 5
        locationButton!.layer.shadowColor = UIColor.blackColor().CGColor
        locationButton!.layer.shadowOffset = CGSizeMake(5, 5)
        locationButton!.layer.shadowRadius = 1
        
        locationButton!.addTarget(self, action: "requestNewUserLocation:", forControlEvents: UIControlEvents.TouchUpInside)
        
        locationButton!.setImage(UIImage(named: "location_yes"), forState: UIControlState.Normal)
        
        self.view.addSubview(locationButton!)
    }
    
    func requestNewUserLocation(sender: UIButton) {
        isSearching = true
        alert!.show()
    }

    
    func onCloudPlaceAroundSearchDone(request:AMapCloudPlaceAroundSearchRequest, response:AMapCloudSearchResponse)
    {
        if isSearching {
            self.alert?.dismissWithClickedButtonIndex(0, animated: true)
            isSearching = false
        }
        updateAvailableBuildings(response.POIs as! [AMapCloudPOI])
        //zoomToFitMapAnnotations()
        updateScrollView()
    }

    func cloudRequest(cloudSearchRequest: AnyObject!, error: NSError!) {
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
            
            return poiAnnotationView;
        }
        return nil
    }
    
    func mapView(mapView: MAMapView!, didSelectAnnotationView view: MAAnnotationView!) {
        view.setSelected(true, animated: false)
        if view.isKindOfClass(AEDBuildingAnnotationView) {
            let aedView = view as! AEDBuildingAnnotationView
            let scrollToPoint = CGPoint(x: self.uiScrollView!.frame.width * CGFloat(aedView.indexNumber!), y: 0)
            self.uiScrollView!.contentOffset = scrollToPoint
        }
    }
    
    func zoomToFitMapAnnotations() {
        if mapView!.annotations.count == 0 {
            return
        }
        
        var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        
        var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)

        if sortedBuildingList != nil && sortedBuildingList?.isEmpty == false {
            for index in 0...min(MAX_NO_OF_BUILDINGS_TO_DISPLAY, sortedBuildingList!.count-1) {
                let coordinate = sortedBuildingList![index].coordinate
                topLeftCoord.longitude = fmin(topLeftCoord.longitude, coordinate.longitude)
                topLeftCoord.latitude = fmax(topLeftCoord.latitude, coordinate.latitude)
                bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, coordinate.longitude)
                bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, coordinate.latitude)
            }
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
        
        if pois.count == 0 {
            let alert = UIAlertController(title: "", message: "无法在附近\(ConfigurationConstants.AMAP_CLOUD_MAP_SEARCH_RADIUS_IN_METER/1000)公里内找到可用的AED。请拨打120急救！", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
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
        clearMapViewAnnotations(self.mapView!)
        for building in sortedBuildingList! {
            let annotation = CustomAnnotation()
            annotation.coordinate = building.coordinate
            annotation.title = "\(index+1). \(building.name)"
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
    
    func clearMapViewAnnotations(mapView: MAMapView) {
        for annotation in mapView.annotations {
            if annotation.isKindOfClass(CustomAnnotation) {
                mapView.removeAnnotation(annotation as! MAAnnotation)
            }
        }
    }
    
    func selecteNthAnnotation(var index: NSInteger) {
        // Here adds 1 because the 0th annotation is user's location
        index += 1
        if self.mapView!.annotations.count < index + 1 {
            return
        }
        self.mapView!.selectAnnotation(self.mapView!.annotations[index] as! MAAnnotation, animated: true)
    }
    
    // MARK: - ScrollView
    
    func updateScrollView() {
        clearScrollView(self.uiScrollView!)
        let noOfAnnotations = self.mapView!.annotations.count

        if noOfAnnotations <= 1 {
            return
        }
        for i in 1...(noOfAnnotations-1) {
            
            let uiView = UIView(frame: CGRectMake(CGFloat(i-1)*self.uiScrollView!.frame.size.width, 0, self.uiScrollView!.frame.size.width, self.uiScrollView!.frame.size.height))
            uiView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
            
            let annotation = self.mapView!.annotations[i] as! CustomAnnotation
            let buildingNameLabel = UILabel(frame: CGRectMake(5, 5, uiView.frame.size.width-50, uiView.frame.size.height/2))
            buildingNameLabel.text = annotation.title!
            uiView.addSubview(buildingNameLabel)
            
            let detailsLabel = UILabel(frame: CGRectMake(20, 10 + uiView.frame.size.height/2, uiView.frame.size.width-50, uiView.frame.size.height/2-15))
            detailsLabel.text = annotation.subtitle!
            detailsLabel.font = UIFont.systemFontOfSize(13)
            uiView.addSubview(detailsLabel)
            
            
            let detailsButton = UIButton(frame: CGRectMake(uiView.frame.size.width - 45, (uiView.frame.size.height-15)/2, 40, 15))
            
            detailsButton.setTitle("详情", forState: UIControlState.Normal)
            detailsButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            detailsButton.titleLabel!.adjustsFontSizeToFitWidth = true
            detailsButton.tag = i
            detailsButton.addTarget(self, action: "triggerShowDetailsView:", forControlEvents: UIControlEvents.TouchUpInside)

            uiView.addSubview(detailsButton)
            
            self.uiScrollView!.addSubview(uiView)
        }
        
        self.uiScrollView!.contentSize = CGSizeMake(CGFloat(self.mapView!.annotations.count-1)*(self.uiScrollView!.frame.width), self.uiScrollView!.frame.size.height)
    }
    
    func triggerShowDetailsView(sender: UIButton) {
        performSegueWithIdentifier("ShowBuildingInfoSegue", sender: self.mapView!.annotations[sender.tag])
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width
        
        self.selecteNthAnnotation(NSInteger(index))
    }
    
    func clearScrollView(scrollView: UIScrollView) {
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowBuildingInfoSegue" {
            let aedDetailViewController = segue.destinationViewController as! BuildingInfoViewController
            let selectedAnnotation = sender as! CustomAnnotation
            let building = selectedAnnotation.customProperties["building"]
            aedDetailViewController.building = building as! BuildingModel
        }
    }
}
