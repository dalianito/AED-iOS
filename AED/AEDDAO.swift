//
//  AEDDAO.swift
//  AED
//
//  Created by Yang Yu on 10/9/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit
import CoreData

private let sharedInstance = AEDDAO()
class AEDDAO : BaseDAO {
    
    override init() {
        super.init()
        entityName = "AED"
    }
    
    class var sharedDAO : AEDDAO {
        return sharedInstance
    }
    
    func insert(aedModel: AEDModel, buildingMO: BuildingMO) {
        let aedMO = AEDMO(entity: self.getEntityDescription()!, insertIntoManagedObjectContext: self.managedObjectContext)
        aedMO.directionToFind = aedModel.directionToFind
        aedMO.floor = aedModel.floor
        aedMO.specificLocation = aedModel.specificLocation
        aedMO.building = buildingMO
        
        do {
            try self.managedObjectContext.save()
            print("Successfully created instance AED")
        } catch {
            print("Error while saving to AED table")
            print(aedModel)
        }
    }
}