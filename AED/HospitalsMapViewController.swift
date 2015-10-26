//
//  HospitalsMapViewController.swift
//  AED
//
//  Created by Yang Yu on 10/21/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit

class HospitalsMapViewController: UIViewController, MAMapViewDelegate, AMapCloudDelegate, UIScrollViewDelegate  {
    
    var cloudAPI : AMapCloudAPI?
    var mapView: ITOMapView?
    var userLastLocationCoordinate2D: CLLocationCoordinate2D?
    var sortedHospitalList: [HospitalModel]?
    var locationButton: UIButton?
    var uiScrollView: UIScrollView?
    var uiScrollViewCurrentPage: NSInteger?
    var isSearching = true
    var alert: UIAlertView?
    var currentAnnotationIndex = 0
    var currentScrollViewPagingIndex = 0
    var forceToRefreshAEDList = false
    
    let SEARCHING_INDICATOR_MSG = "正在搜索附近\(ConfigurationConstants.AMAP_CLOUD_MAP_SEARCH_RADIUS_IN_METER/1000)公里内的医院..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.uiScrollView = UIScrollView(frame: CGRectMake(tabBarItemWidth, self.tabBarController!.tabBar.frame.origin.y - tabBarHeight*2 - 20, tabBarItemWidth*3, tabBarHeight))
        self.uiScrollView!.delegate = self
        
        self.view.addSubview(self.uiScrollView!)
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.uiScrollView!.bounces = false
        self.uiScrollView!.pagingEnabled = true
        self.uiScrollView!.showsHorizontalScrollIndicator = false
        self.uiScrollView!.showsVerticalScrollIndicator = false
    }
    
    func sortHospitalList() {
        sortedHospitalList!.sortInPlace({$0.distance < $1.distance})
    }
    
    func refreshAEDList() {
        if userLastLocationCoordinate2D == nil {
            return
        }
        
        let latitude = Double(userLastLocationCoordinate2D!.latitude)
        let longitude = Double(userLastLocationCoordinate2D!.longitude)
        let centerPoint =  AMapCloudPoint.locationWithLatitude(CGFloat(latitude), longitude: CGFloat(longitude))
        
        let placeAroundRequest =  AMapCloudPlaceAroundSearchRequest()
        placeAroundRequest.tableID = ConfigurationConstants.AMAP_CLOUD_MAP_HOSPITAL_TABLE_ID
        placeAroundRequest.radius = ConfigurationConstants.AMAP_CLOUD_MAP_SEARCH_RADIUS_IN_METER
        placeAroundRequest.center = centerPoint
        placeAroundRequest.offset = 20
        
        self.cloudAPI!.AMapCloudPlaceAroundSearch(placeAroundRequest)
    }
    
    func mapView(mapView: MAMapView!, didUpdateUserLocation userLocation: MAUserLocation!, updatingLocation: Bool) {
        if isSearching == false {
            return
        }
        
        if forceToRefreshAEDList {
            forceToRefreshAEDList = false
            refreshAEDList()
        }
        
        if (updatingLocation && isNewCoordinate(userLocation.coordinate)) || sortedHospitalList == nil || sortedHospitalList!.isEmpty{
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
        mapView = ITOMapView(frame: self.view.frame)
        mapView!.delegate = self
        self.view.addSubview(mapView!)
        
        userLastLocationCoordinate2D = nil
        
        locationButton = UIButton(frame: CGRectMake(10, self.tabBarController!.tabBar.frame.origin.y - 10, 40, 40))
        locationButton!.autoresizingMask = [UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleTopMargin]
        locationButton!.layer.cornerRadius = 5
        
        locationButton!.addTarget(self, action: "requestNewUserLocation:", forControlEvents: UIControlEvents.TouchUpInside)
        
        locationButton!.setImage(UIImage(named: "location_yes"), forState: UIControlState.Normal)
        
        self.view.addSubview(locationButton!)
    }
    
    func requestNewUserLocation(sender: UIButton) {
        isSearching = true
        forceToRefreshAEDList = true
        alert!.show()
    }
    
    
    func onCloudPlaceAroundSearchDone(request:AMapCloudPlaceAroundSearchRequest, response:AMapCloudSearchResponse)
    {
        if isSearching == false {
            return
        }
        self.alert?.dismissWithClickedButtonIndex(0, animated: true)
        isSearching = false
        
        updateAvailableHospitals(response.POIs as! [AMapCloudPOI])
        self.mapView!.zoomToFitAnnotations((0...response.POIs.count).map{$0})
        updateScrollView()
    }
    
    func cloudRequest(cloudSearchRequest: AnyObject!, error: NSError!) {
        if isSearching == false {
            return
        }
        self.alert?.dismissWithClickedButtonIndex(0, animated: true)
        isSearching = false
        let alert = UIAlertController(title: "", message: "请求失败，请重试！原因：\(error.localizedDescription) 请拨打120急救！", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func mapView(mapView:MAMapView, viewForAnnotation annotation:MAAnnotation) ->MAAnnotationView? {
        
        if annotation.isKindOfClass(CustomAnnotation) {
            let annotationIdentifier = "hospitalIdentifier"
            
            var poiAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier) as? HospitalAnnotationView
            
            if poiAnnotationView == nil {
                poiAnnotationView = HospitalAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            } else {
                poiAnnotationView!.setCustomAnnotation(annotation as! CustomAnnotation)
            }
            
            return poiAnnotationView;
        }
        return nil
    }
    
    func mapView(mapView: MAMapView!, didSelectAnnotationView view: MAAnnotationView!) {
        if view.isKindOfClass(HospitalAnnotationView) {
            let aedView = view as! HospitalAnnotationView
            currentAnnotationIndex = aedView.indexNumber!
            if currentAnnotationIndex == currentScrollViewPagingIndex {
                return
            }
            
            let scrollToPoint = CGPoint(x: self.uiScrollView!.frame.width * CGFloat(aedView.indexNumber!), y: 0)
            self.uiScrollView!.contentOffset = scrollToPoint
        }
    }
    
    func updateAvailableHospitals(pois: [AMapCloudPOI]) {
        
        if pois.count == 0 {
            let alert = UIAlertController(title: "", message: "无法在附近\(ConfigurationConstants.AMAP_CLOUD_MAP_SEARCH_RADIUS_IN_METER/1000)公里内找到可用的AED。请拨打120急救！", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        sortedHospitalList = [HospitalModel]()
        
        for poi in pois {
            let customFields = poi.customFields
               let hospital = HospitalModel()
                hospital.name = poi.name
                hospital.address = poi.address
                hospital.distance = poi.distance
                hospital.coordinate = CLLocationCoordinate2DMake(Double(poi.location.latitude), Double(poi.location.longitude))
                hospital.phone = (customFields["telephone"] as? String)!

            
            sortedHospitalList!.append(hospital)
        }
        
        sortHospitalList()
        
        var index = 0
        var firstAnnotation : CustomAnnotation?
        clearMapViewAnnotations(self.mapView!)
        for hospital in sortedHospitalList! {
            let annotation = CustomAnnotation()
            annotation.coordinate = hospital.coordinate!
            annotation.title = "\(index+1). \(hospital.name)"
            annotation.subtitle = "\(hospital.distance)m"
            annotation.customProperties["hospital"] = hospital
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
    
    func selectNthAnnotation(var index: NSInteger) {
        if currentAnnotationIndex == index {
            return
        }
        // Here adds 1 because the 0th annotation is user's location
        index += 1
        if self.mapView!.annotations.count < index + 1 {
            return
        }
        
        currentAnnotationIndex = index - 1
        self.mapView!.selectAnnotation(self.mapView!.annotations[index] as! MAAnnotation, animated: true)
        
        self.mapView!.zoomToFitAnnotations([0, index])
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
            uiView.backgroundColor = UIColor.whiteColor()
            
            let annotation = self.mapView!.annotations[i] as! CustomAnnotation
            let hospitalNameLabel = UILabel(frame: CGRectMake(5, 5, uiView.frame.size.width-50, uiView.frame.size.height/2))
            hospitalNameLabel.text = annotation.title!
            uiView.addSubview(hospitalNameLabel)
            
            let detailsLabel = UILabel(frame: CGRectMake(20, 10 + uiView.frame.size.height/2, uiView.frame.size.width-50, uiView.frame.size.height/2-15))
            detailsLabel.text = annotation.subtitle!
            detailsLabel.font = UIFont.systemFontOfSize(13)
            uiView.addSubview(detailsLabel)
            
            
            let detailsButton = UIButton(frame: CGRectMake(uiView.frame.size.width - 45, 0, 50, self.uiScrollView!.frame.height))
            
            detailsButton.setImage(UIImage(named: "detailsBtn"), forState: UIControlState.Normal)
            detailsButton.tag = i
            detailsButton.addTarget(self, action: "triggerShowDetailsView:", forControlEvents: UIControlEvents.TouchUpInside)
            
            uiView.addSubview(detailsButton)
            
            self.uiScrollView!.addSubview(uiView)
        }
        
        self.uiScrollView!.contentSize = CGSizeMake(CGFloat(self.mapView!.annotations.count-1)*(self.uiScrollView!.frame.width), self.uiScrollView!.frame.size.height)
    }
    
    func triggerShowDetailsView(sender: UIButton) {
        performSegueWithIdentifier("ShowHospitalInfoSegue", sender: self.mapView!.annotations[sender.tag])
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let newPagingIndex = getScrollViewCurrentPageNumber(scrollView)
        if newPagingIndex != currentScrollViewPagingIndex {
            currentScrollViewPagingIndex = newPagingIndex
            self.selectNthAnnotation(currentScrollViewPagingIndex)
        }
    }
    
    func getScrollViewCurrentPageNumber(scrollView: UIScrollView) -> NSInteger {
        let index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width
        return NSInteger(index)
    }
    
    func clearScrollView(scrollView: UIScrollView) {
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowHospitalInfoSegue" {
            let aedDetailViewController = segue.destinationViewController as! HospitalInfoViewController
            let selectedAnnotation = sender as! CustomAnnotation
            let hospital = selectedAnnotation.customProperties["hospital"]
            aedDetailViewController.hospital = hospital as? HospitalModel
        }
    }

}
