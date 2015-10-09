//
//  BuildingDAO.swift
//  AED
//
//  Created by Yang Yu on 10/9/15.
//  Copyright © 2015 iTO. All rights reserved.
//

import UIKit
import CoreData

private let sharedInstance = BuildingDAO()
class BuildingDAO : BaseDAO {

    override init() {
        super.init()
        entityName = "Building"
    }
    
    class var sharedDAO : BuildingDAO {
        return sharedInstance
    }
    
    func insert(building: BuildingModel) {
        let buildingMO = BuildingMO(entity: self.getEntityDescription()!, insertIntoManagedObjectContext: self.managedObjectContext)
        buildingMO.name = building.name
        buildingMO.address = building.address
        buildingMO.phone = building.phone
        
        for aed in building.aeds {
            let aedEntityDescription = NSEntityDescription.entityForName("AED", inManagedObjectContext: self.managedObjectContext)!
            let aedMO = AEDMO(entity: aedEntityDescription, insertIntoManagedObjectContext: self.managedObjectContext)
            aedMO.floor = aed.floor
            aedMO.specificLocation = aed.specificLocation
            aedMO.directionToFind = aed.directionToFind
            buildingMO.mutableSetValueForKey("aeds").addObject(aedMO)
        }
        
        do {
            try self.managedObjectContext.save()
            print("Successfully created instance Building")
        } catch {
            print("Error while saving to Building table")
            print(building)
        }
    }
    
    func selectByFetchRequest(fetchRequest: NSFetchRequest) -> [BuildingModel] {
        fetchRequest.entity = self.getEntityDescription()
        var buildingModels = [BuildingModel]()
        do {
            let results = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            print("Selected \(results.count) results")
            
            for result in results {
                let buildingMO = result as! BuildingMO
                buildingModels.append(BuildingModel.fromMO(buildingMO))
            }
        } catch {
            print("error while retrieve data")
        }
        
        return buildingModels
    }

}
