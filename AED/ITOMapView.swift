//
//  ITOMapView.swift
//  AED
//
//  Created by Yang Yu on 10/21/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit

class ITOMapView: MAMapView {
    
    // MARK: Properties
    var isSearching = true
    var isForceToRefresh = false
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDefaults()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setDefaults() {
        showsUserLocation = true
        setUserTrackingMode(MAUserTrackingMode.Follow, animated: true)
        desiredAccuracy = kCLLocationAccuracyBest
        distanceFilter = ConfigurationConstants.AMAP_DISTANCE_FILTER_IN_METER
        showsCompass = false
        showsScale = false
        zoomEnabled = true
    }
    
    // MARK: Util Functions
    
    func zoomToFitAnnotations(indice: [NSInteger]) -> Bool{
        if annotations.count == 0 {
            return false
        }
        
        var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        
        var doesRequireZooming = false
        for index in indice {
            if (index >= annotations.count) {
                continue
            }
            
            let coordinate = annotations[index].coordinate
            if isInRegion(coordinate)  == false{
                doesRequireZooming = true
            }
            
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, coordinate.longitude)
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, coordinate.latitude)
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, coordinate.longitude)
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, coordinate.latitude)
        }
        
        if doesRequireZooming == false {
            return false
        }
        
        setRegion(createNewRegion(topLeftCoord, bottomRightCoord: bottomRightCoord), animated: false)
        
        return true
    }
    
    private func createNewRegion(topLeftCoord: CLLocationCoordinate2D, bottomRightCoord: CLLocationCoordinate2D) -> MACoordinateRegion {
        
        var newRegion = MACoordinateRegion()
        newRegion.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5
        newRegion.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5
        newRegion.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.3
        newRegion.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.3
        
        return newRegion
    }
    
    func isInRegion(targetPoint: CLLocationCoordinate2D) -> Bool {
        
        let latitudeDiff = region.span.latitudeDelta/2
        let longitudeDiff = region.span.longitudeDelta/2
        let center = region.center
        
        if targetPoint.latitude < center.latitude - latitudeDiff
            || targetPoint.latitude > center.latitude + latitudeDiff
            || targetPoint.longitude < center.longitude - longitudeDiff
            || targetPoint.longitude > center.longitude + longitudeDiff {
                return false
        } else {
            return true
        }
    }
    
    // MARK: Overriding Default Functions

    // MARK: Call Backs
    
}
