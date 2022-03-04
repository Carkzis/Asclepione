//
//  UptakePercentages+CoreDataProperties.swift
//  Asclepione
//
//  Created by Marc Jowett on 04/03/2022.
//
//

import Foundation
import CoreData

public class UptakePercentages: NSManagedObject {}

extension UptakePercentages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UptakePercentages> {
        return NSFetchRequest<UptakePercentages>(entityName: "UptakePercentages")
    }

    @NSManaged public var areaName: String?
    @NSManaged public var date: Date?
    @NSManaged public var firstDoseUptakePercentage: Float
    @NSManaged public var id: String?
    @NSManaged public var secondDoseUptakePercentage: Float
    @NSManaged public var thirdDoseUptakePercentage: Float

}

extension UptakePercentages : Identifiable {}
