//
//  AEDMO+CoreDataProperties.swift
//  AED
//
//  Created by Yang Yu on 10/9/15.
//  Copyright © 2015 iTO. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AEDMO {

    @NSManaged var directionToFind: String?
    @NSManaged var floor: String?
    @NSManaged var syncVersionNumber: NSNumber?
    @NSManaged var specificLocation: String?
    @NSManaged var building: BuildingMO?

}
