//
//  CumulativeVaccinations+CoreDataProperties.swift
//  Asclepione
//
//  Created by Marc Jowett on 04/03/2022.
//
//

import Foundation
import CoreData

protocol CumulativeVaccinationsEntity {
    var areaName: String? { get set }
    var cumulativeFirstDoses: Int16 { get set }
    var cumulativeSecondDoses: Int16 { get set }
    var cumulativeThirdDoses: Int16 { get set }
    var date: Date? { get set }
    var id: String? { get set }
    var cumulativeVaccinations: Int16 { get set }
}

public class CumulativeVaccinations: NSManagedObject, CumulativeVaccinationsEntity {}

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
    
    static var entityName: String { return "CumulativeVaccinations" }

}

extension CumulativeVaccinations : Identifiable {}

