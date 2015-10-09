//
//  BuildingMO+CoreDataProperties.swift
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

extension BuildingMO {

    @NSManaged var address: String?
    @NSManaged var name: String?
    @NSManaged var phone: String?
    @NSManaged var syncVersionNumber: NSNumber?
    @NSManaged var aeds: NSSet?

}
