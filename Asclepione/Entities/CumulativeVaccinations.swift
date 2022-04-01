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
    var cumulativeFirstDoses: Int32 { get set }
    var cumulativeSecondDoses: Int32 { get set }
    var cumulativeThirdDoses: Int32 { get set }
    var date: Date? { get set }
    var id: String? { get set }
    var cumulativeVaccinations: Int32 { get set }
}

public class CumulativeVaccinations: NSManagedObject, CumulativeVaccinationsEntity {}

extension CumulativeVaccinations {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CumulativeVaccinations> {
        return NSFetchRequest<CumulativeVaccinations>(entityName: "CumulativeVaccinations")
    }

    @NSManaged public var areaName: String?
    @NSManaged public var cumulativeFirstDoses: Int32
    @NSManaged public var cumulativeSecondDoses: Int32
    @NSManaged public var cumulativeThirdDoses: Int32
    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var cumulativeVaccinations: Int32
    
    static var entityName: String { return "CumulativeVaccinations" }

}

extension CumulativeVaccinations : Identifiable {}

