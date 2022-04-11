//
//  UptakePercentages+CoreDataProperties.swift
//  Asclepione
//
//  Created by Marc Jowett on 04/03/2022.
//
//

import Foundation
import CoreData

/**
 Represents the vaccination uptake as a percentage of the population of an area, held within the CoreData database.
 */
protocol UptakePercentagesEntity {
    var areaName: String? { get set }
    var date: Date? { get set }
    var firstDoseUptakePercentage: Float { get set }
    var id: String? { get set }
    var secondDoseUptakePercentage: Float { get set }
    var thirdDoseUptakePercentage: Float { get set }
}

public class UptakePercentages: NSManagedObject, UptakePercentagesEntity {}

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
    
    static var entityName: String { return "UptakePercentages" }

}

extension UptakePercentages : Identifiable {}
