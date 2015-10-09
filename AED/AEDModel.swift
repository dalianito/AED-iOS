//
//  AED.swift
//  AED
//
//  Created by Yang Yu on 10/8/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit

class AEDModel {
    
    // Mark: Properties
    var building : BuildingModel!
    var floor : String!
    var specificLocation : String!
    var directionToFind : String!
    
    init() {
    }
    
    init(floor: String, specificLocation: String, directionToFind: String) {
        self.floor = floor
        self.specificLocation = specificLocation
        self.directionToFind = directionToFind
    }
    
    static func fromMO(aedMO: AEDMO) -> AEDModel {
        let aed = AEDModel()
        aed.floor = aedMO.floor
        aed.specificLocation = aedMO.specificLocation
        aed.directionToFind = aedMO.directionToFind
        
        return aed
    }
}
