//
//  Weight.swift
//  Pet Vet
//
//  Created by Christopher Burgess on 11/13/15.
//  Copyright © 2015 Christopher Burgess. All rights reserved.
//

import Foundation
import CoreData

@objc (Weight)

class Weight: NSManagedObject {
     
     @NSManaged var weight: Double
     @NSManaged var date: NSDate
     @NSManaged var pet: Pet?
     
     override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
          super.init(entity: entity, insertIntoManagedObjectContext: context)
     }

     init(weight: Double, date: NSDate, context: NSManagedObjectContext) {
          let entity = NSEntityDescription.entityForName("Weight", inManagedObjectContext: context)!
          super.init(entity: entity, insertIntoManagedObjectContext: context)
          
          self.weight = weight
          self.date = date
     }
     
}