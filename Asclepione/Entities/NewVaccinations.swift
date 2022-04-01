//
//  NewVaccinations+CoreDataProperties.swift
//  Asclepione
//
//  Created by Marc Jowett on 04/03/2022.
//
//

import Foundation
import CoreData

protocol NewVaccinationsEntity {
    var areaName: String? { get set }
    var date: Date? { get set }
    var id: String? { get set }
    var newFirstDoses: Int32 { get set }
    var newSecondDoses: Int32 { get set }
    var newThirdDoses: Int32 { get set }
    var newVaccinations: Int32 { get set }
}

public class NewVaccinations: NSManagedObject, NewVaccinationsEntity {}

extension NewVaccinations {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewVaccinations> {
        return NSFetchRequest<NewVaccinations>(entityName: "NewVaccinations")
    }

    @NSManaged public var areaName: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var newFirstDoses: Int32
    @NSManaged public var newSecondDoses: Int32
    @NSManaged public var newThirdDoses: Int32
    @NSManaged public var newVaccinations: Int32
    
    static var entityName: String { return "NewVaccinations" }

}

extension NewVaccinations : Identifiable {}
