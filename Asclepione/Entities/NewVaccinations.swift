//
//  NewVaccinations+CoreDataProperties.swift
//  Asclepione
//
//  Created by Marc Jowett on 04/03/2022.
//
//

import Foundation
import CoreData

open class NewVaccinations: NSManagedObject {}

extension NewVaccinations {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewVaccinations> {
        return NSFetchRequest<NewVaccinations>(entityName: "NewVaccinations")
    }

    @NSManaged open var areaName: String?
    @NSManaged open var date: Date?
    @NSManaged open var id: String?
    @NSManaged open var newFirstDoses: Int16
    @NSManaged open var newSecondDoses: Int16
    @NSManaged open var newThirdDoses: Int16
    @NSManaged open var newVaccinations: Int16
    
    static var entityName: String { return "NewVaccinations" }

}

extension NewVaccinations : Identifiable {}
