//
//  HospitalModel.swift
//  AED
//
//  Created by Yang Yu on 10/20/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit

class HospitalModel {
    var name: String
    var address: String
    var phone: String
    var coordinate: CLLocationCoordinate2D?
    var distance: Int
    
    init(){
        name = ConfigurationConstants.EMPTY_PROPERTY_STR
        address = ConfigurationConstants.EMPTY_PROPERTY_STR
        phone = ConfigurationConstants.EMPTY_PROPERTY_STR
        distance = -100000
    }
}
