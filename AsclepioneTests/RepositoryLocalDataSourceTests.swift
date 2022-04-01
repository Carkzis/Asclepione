//
//  RepositoryLocalDataSourceTests.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 08/03/2022.
//

import XCTest
import CoreData
import Combine

@testable import Asclepione

class RepositoryLocalDataSourceTests: XCTestCase {
    var sut: FakeRepository!
    var managedObjectContext: NSManagedObjectContext!
    
    @Published var newVaccinationsEngland: NewVaccinationsDomainObject = NewVaccinationsDomainObject(country: nil, date: nil, newVaccinations: nil)
    @Published var cumVaccinationsEngland: [CumulativeVaccinationsDomainObject] = []
    @Published var uptakePercentagesEngland: [UptakePercentageDomainObject] = []
    
    private var isNewVaccinationsPublisher: AnyPublisher<NewVaccinationsDomainObject, Never> {
        sut.$newVaccinationsEngland
            .receive(on: RunLoop.main)
            .map {
                $0
            }
            .eraseToAnyPublisher()
    }
    private var isCumVaccinationsPublisher: AnyPublisher<[CumulativeVaccinationsDomainObject], Never> {
        sut.$cumVaccinationsEngland
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    private var isUptakePercentagesPublisher: AnyPublisher<[UptakePercentageDomainObject], Never> {
        sut.$uptakePercentagesEngland
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        sut = FakeRepository()
//        isNewVaccinationsPublisher
//            .receive(on: RunLoop.main)
//            .sink { [weak self] in
//                self?.newVaccinationsEngland = $0
//                print("NOOOO?")
//                print(self?.newVaccinationsEngland)
//            }
//            .store(in: &cancellables)
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
            print("Something went wrong fetching vaccination data: \(error)")
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
    
    func testDataRetrievedAndPublishedByCombineOnInitialisation() throws {
        // Given a FakeRepository and a blank in-memory database.
        sut.refreshVaccinationData()
        let expectation = XCTestExpectation(description: "Retrieve data from database via Publisher.")
        
        // Then the data from the CoreData database should be published using Combine.
        let cancellable = isNewVaccinationsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.newVaccinationsEngland = $0
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 10)
        cancellable.cancel()
    }
}
