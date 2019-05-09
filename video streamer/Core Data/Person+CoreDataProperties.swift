//
//  Person+CoreDataProperties.swift
//  ugggh
//
//  Created by Connor Woodford on 5/28/18.
//  Copyright © 2018 Connor Woodford. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int16

}
