//
//  RepositoryLocalDataSourceTests.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 08/03/2022.
//

import XCTest
import CoreData

@testable import Asclepione

class RepositoryLocalDataSourceTests: XCTestCase {
    var sut: FakeRepository!
    var managedObjectContext: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        sut = FakeRepository()
        print(PersistenceController.shared.container)
        managedObjectContext = PersistenceController.shared.container.viewContext
    }

    override func tearDownWithError() throws {
        sut = nil
        managedObjectContext = nil
    }
    
    func testSavingMultipleDuplicateEntriesIntoCoreDataResultsInOneEntryBeingStoredForEachEntity() throws {
        // Given a FakeRepository and a blank in-memory database, when VaccinationData is refreshed.
        sut.refreshVaccinationData()
        
        // Then we can retrieve 1 item of data from each entity.
        let newVaccinationsFetchRequest = NSFetchRequest<NewVaccinations>(entityName: NewVaccinations.entityName)
        let cumVaccinationsFetchRequest = NSFetchRequest<CumulativeVaccinations>(entityName: CumulativeVaccinations.entityName)
        let percentagesFetchRequest = NSFetchRequest<UptakePercentages>(entityName: UptakePercentages.entityName)
        do {
            let newVaccinationsData = try managedObjectContext.fetch(newVaccinationsFetchRequest)
            print("New Vaccinations: \(newVaccinationsData)")
            XCTAssertTrue(newVaccinationsData.count == 1)

            let cumVaccinationsData = try managedObjectContext.fetch(cumVaccinationsFetchRequest)
            print("Cumulative Vaccinations: \(cumVaccinationsData)")
            XCTAssertTrue(cumVaccinationsData.count == 1)

            let percentagesData = try managedObjectContext.fetch(percentagesFetchRequest)
            print("Uptake Percentages: \(percentagesData)")
            XCTAssertTrue(percentagesData.count == 1)
        } catch {
            print("Something went wrong fetching employees: \(error)")
        }
    }
    
    func testSavingMultipleUniqueEntriesIntoCoreDataResultsInMultipleEntriesBeingStoredForEachEntity() throws {
        // Given a FakeRepository and a blank in-memory database, when VaccinationData is refreshed with unique data.
        sut.multipleUniqueDataItemsReceived = true
        sut.refreshVaccinationData()
        
        // Then we can retrieve multiple items of data from each entity, as they are unique.
        let newVaccinationsFetchRequest = NSFetchRequest<NewVaccinations>(entityName: NewVaccinations.entityName)
        let cumVaccinationsFetchRequest = NSFetchRequest<CumulativeVaccinations>(entityName: CumulativeVaccinations.entityName)
        let percentagesFetchRequest = NSFetchRequest<UptakePercentages>(entityName: UptakePercentages.entityName)
        do {
            let newVaccinationsData = try managedObjectContext.fetch(newVaccinationsFetchRequest)
            print("New Vaccinations: \(newVaccinationsData)")
            XCTAssertTrue(newVaccinationsData.count > 1)

            let cumVaccinationsData = try managedObjectContext.fetch(cumVaccinationsFetchRequest)
            print("Cumulative Vaccinations: \(cumVaccinationsData)")
            XCTAssertTrue(cumVaccinationsData.count > 1)

            let percentagesData = try managedObjectContext.fetch(percentagesFetchRequest)
            print("Uptake Percentages: \(percentagesData)")
            XCTAssertTrue(percentagesData.count > 1)
        } catch {
            print("Something went wrong fetching employees: \(error)")
        }
    }
}
