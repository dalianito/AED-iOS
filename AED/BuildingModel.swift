//
//  Building.swift
//  AED
//
//  Created by Yang Yu on 10/8/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit

class BuildingModel {
    
    // Mark: Properties
    var buildingID: String!
    var name : String!
    var phone : String!
    var address : String!
    var distance : Int!
    var coordinate: CLLocationCoordinate2D!
    var aeds = [AEDModel]()
    
    // Mark: Initialization
    init() {
    }
    init?(name: String, phone: String, address: String) {
        if name.isEmpty || phone.isEmpty || address.isEmpty {
            print("name or phone or address is empty")
            return nil
        }
        self.name = name
        self.phone = phone
        self.address = address
    }
    
    func getAEDs() -> [AEDModel] {
        return aeds
    }
    
    func getAED(index: Int!) -> AEDModel {
        return aeds[index]
    }
    
    static func fromMO(buildingMO: BuildingMO) -> BuildingModel {
        let buildingModel = BuildingModel()
        buildingModel.name = buildingMO.name
        buildingModel.phone = buildingMO.phone
        buildingModel.address = buildingMO.address
        
        if buildingMO.aeds != nil {
        for aedMO in (buildingMO.aeds?.allObjects)! {
            let aed = AEDModel.fromMO(aedMO as! AEDMO)
            aed.building = buildingModel
            buildingModel.aeds.append(aed)
        }
        }
        return buildingModel
    }
}
