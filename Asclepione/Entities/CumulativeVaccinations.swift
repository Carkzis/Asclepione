//
//  CumulativeVaccinations+CoreDataProperties.swift
//  Asclepione
//
//  Created by Marc Jowett on 04/03/2022.
//
//

import Foundation
import CoreData

public class CumulativeVaccinations: NSManagedObject {}

extension CumulativeVaccinations {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CumulativeVaccinations> {
        return NSFetchRequest<CumulativeVaccinations>(entityName: "CumulativeVaccinations")
    }

    @NSManaged public var areaName: String?
    @NSManaged public var cumulativeFirstDoses: Int16
    @NSManaged public var cumulativeSecondDoses: Int16
    @NSManaged public var cumulativeThirdDoses: Int16
    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var cumulativeVaccinations: Int16

}

extension CumulativeVaccinations : Identifiable {}

