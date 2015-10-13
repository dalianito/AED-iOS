//
//  AEDTableViewController.swift
//  AED
//
//  Created by Yang Yu on 10/8/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit
import CoreData

class AEDTableViewController: UITableViewController, MAMapViewDelegate, AMapCloudDelegate {
    
    // Mark: Properties
    var availableBuildings = [BuildingModel]()
    var cloudAPI: AMapCloudAPI?
    var mapView: MAMapView?
    var userLastLocationCoordinate2D: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()

        initMapView()
        initAMapCloudAPI()

        //let request = NSFetchRequest()
        //availableBuildings = BuildingDAO.sharedDAO.selectByFetchRequest(request)
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
    }


    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source for section

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return availableBuildings.count
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("SectionHeaderCell") as! BuildingTableViewSectionCell
        let building = availableBuildings[section]
        headerCell.buildingNameLabel.text = "\(building.name)"
        headerCell.distanceLabel.text = "\(building.distance)米"
        
        return headerCell
    }
    
    // MARK: - Table view data source for cell
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableBuildings[section].getAEDs().count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "AEDInfoCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AEDInfoTableViewCell
        cell.aed = availableBuildings[indexPath.section].getAED(indexPath.row)
        cell.setView()
        
        return cell
    }
    
    func handleRefresh(refreshControl: UIRefreshControl?) {
        refreshAEDList()
    }
    
    func refreshAEDList() {
        print("h")
        if userLastLocationCoordinate2D == nil {
            self.refreshControl?.endRefreshing()
            return
        }
        print("Refreshing AED list with coordinate \(userLastLocationCoordinate2D)")
        
        let radius =  5000 // 5 KM
        let latitude = Double(userLastLocationCoordinate2D!.latitude)
        let longitude = Double(userLastLocationCoordinate2D!.longitude)
        let centerPoint =  AMapCloudPoint.locationWithLatitude(CGFloat(latitude), longitude: CGFloat(longitude))
        
        let placeAroundRequest =  AMapCloudPlaceAroundSearchRequest()
        placeAroundRequest.tableID = ConfigurationConstants.AMAP_CLOUD_MAP_TABLE_ID
        placeAroundRequest.radius = radius
        placeAroundRequest.center = centerPoint
        placeAroundRequest.keywords = ""
        placeAroundRequest.offset = 20
        
        self.cloudAPI!.AMapCloudPlaceAroundSearch(placeAroundRequest)
    }
    
    func updateAvailableBuildings(pois: [AMapCloudPOI]) {
        availableBuildings = [BuildingModel]()
        for poi in pois {
            let building = BuildingModel()
            building.name = poi.name
            building.address = poi.address
            building.distance = poi.distance
            
            
            let customFields = poi.customFields
            let aed = AEDModel()
            aed.floor = customFields["floor"] as? String
            aed.specificLocation = customFields["location"] as? String
            aed.directionToFind = customFields["directionToFind"] as? String
            aed.building = building
            building.aeds.append(aed)
            
            availableBuildings.append(building)
        }
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - AMap
    func initMapView() {
        MAMapServices.sharedServices().apiKey = ConfigurationConstants.AMAP_CLOUD_MAP_API_KEY
        mapView = MAMapView(frame: self.view.bounds)
        mapView!.showsUserLocation = true
        mapView!.delegate = self
    }
    
    func initAMapCloudAPI(){
        self.cloudAPI = AMapCloudAPI(cloudKey:ConfigurationConstants.AMAP_CLOUD_MAP_API_KEY, delegate:nil)
        self.cloudAPI?.delegate = self;
    }
    
    func mapView(mapView: MAMapView!, didUpdateUserLocation userLocation: MAUserLocation!, updatingLocation: Bool) {
        if updatingLocation && isNewCoordinate(userLocation.coordinate) {
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
    
    
    func onCloudPlaceAroundSearchDone(request:AMapCloudPlaceAroundSearchRequest, response:AMapCloudSearchResponse)
    {
        print("hello world")
        print(response.count)
        updateAvailableBuildings(response.POIs as! [AMapCloudPOI])
        
        if response.count == 0 {
            let alert = UIAlertController(title: "", message: "5公里范围内没有可用的AED。请重新定位或搜索！请拨打120急救！", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func cloudRequest(cloudSearchRequest: AnyObject!, error: NSError!) {
        print("ERROR while sending cloud request")
        print(error)
    }




    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "ShowDetail" {
            let aedDetailViewController = segue.destinationViewController as! ViewController
            let selectedAEDInfoCell = sender as! AEDInfoTableViewCell
            
            aedDetailViewController.aed = selectedAEDInfoCell.aed
        }
    }

}
