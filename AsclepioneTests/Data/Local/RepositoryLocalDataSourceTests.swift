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
    
    var newVaccinations: NewVaccinationsDomainObject = NewVaccinationsDomainObject(country: nil, date: nil, newVaccinations: nil)
    var cumVaccinations: CumulativeVaccinationsDomainObject = CumulativeVaccinationsDomainObject(country: nil, date: nil, cumulativeVaccinations: nil)
    var uptakePercentages: UptakePercentageDomainObject = UptakePercentageDomainObject(country: nil, date: nil, thirdDoseUptakePercentage: nil)
    
    private var isNewVaccinationsPublisher: AnyPublisher<NewVaccinationsDomainObject, Never> {
        sut.newVaccinationsPublisher
            .eraseToAnyPublisher()
    }
    private var isCumVaccinationsPublisher: AnyPublisher<CumulativeVaccinationsDomainObject, Never> {
        sut.cumVaccinationsPublisher
            .eraseToAnyPublisher()
    }
    private var isUptakePercentagesPublisher: AnyPublisher<UptakePercentageDomainObject, Never> {
        sut.uptakePercentagesPublisher
            .eraseToAnyPublisher()
    }
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        sut = FakeRepository()
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
            XCTAssertTrue(newVaccinationsData.count == 1)

            let cumVaccinationsData = try managedObjectContext.fetch(cumVaccinationsFetchRequest)
            XCTAssertTrue(cumVaccinationsData.count == 1)

            let percentagesData = try managedObjectContext.fetch(percentagesFetchRequest)
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
            XCTAssertTrue(newVaccinationsData.count > 1)

            let cumVaccinationsData = try managedObjectContext.fetch(cumVaccinationsFetchRequest)
            XCTAssertTrue(cumVaccinationsData.count > 1)

            let percentagesData = try managedObjectContext.fetch(percentagesFetchRequest)
            XCTAssertTrue(percentagesData.count > 1)
        } catch {
            print("Something went wrong fetching employees: \(error)")
        }
    }
    
    func testEntitiesRetrievedOnInitialisationAndConvertedToDomainObjectsAndPublishedByCombineOnInitialisation() throws {
        // Given a FakeRepository and a blank in-memory database.
        let newVaccExpectation = XCTestExpectation(description: "Retrieve new vaccination data from database via Publisher.")
        let cumVaccExpectation = XCTestExpectation(description: "Retrieve cumulative vaccination data from database via Publisher.")
        let uptakePercentageExpectation = XCTestExpectation(description: "Retrieve uptake percentage data from database via Publisher.")
        
        // Then the data from the CoreData database should be published using Combine on initialisation.
        cancellables = getCancellables(newVaccExpectation: newVaccExpectation, cumVaccExpectation: cumVaccExpectation, uptakePercentageExpectation: uptakePercentageExpectation)
        
        wait(for: [newVaccExpectation], timeout: 10)
        wait(for: [cumVaccExpectation], timeout: 10)
        wait(for: [uptakePercentageExpectation], timeout: 10)
        verifyEntitiesConvertedToDomainObjects(newVaccinations: self.newVaccinations,
                                               cumVaccinations: self.cumVaccinations,
                                               uptakePercentages: self.uptakePercentages,
                                               newDataReceived: false)
        
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
    
    func testEntitiesRetrievedOnRefreshAndConvertedToDomainObjectsAndPublishedByCombineOnInitialisation() throws {
        // Given a FakeRepository and a blank in-memory database.
        sut.multipleUniqueDataItemsReceived = true
        let newVaccExpectation = XCTestExpectation(description: "Retrieve new vaccination data from database via Publisher.")
        let cumVaccExpectation = XCTestExpectation(description: "Retrieve cumulative vaccination data from database via Publisher.")
        let uptakePercentageExpectation = XCTestExpectation(description: "Retrieve uptake percentage data from database via Publisher.")
        
        // When the data is refreshed.
        sut.newDataReceived = true
        sut.refreshVaccinationData()
        
        // Then the data from the CoreData database should be published using Combine.
        let cancellables = getCancellables(newVaccExpectation: newVaccExpectation, cumVaccExpectation: cumVaccExpectation, uptakePercentageExpectation: uptakePercentageExpectation)
        
        wait(for: [newVaccExpectation], timeout: 10)
        wait(for: [cumVaccExpectation], timeout: 10)
        wait(for: [uptakePercentageExpectation], timeout: 10)
        verifyEntitiesConvertedToDomainObjects(newVaccinations: self.newVaccinations,
                                               cumVaccinations: self.cumVaccinations,
                                               uptakePercentages: self.uptakePercentages,
                                               newDataReceived: true)
        
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
    
    func testLatestEntitiesRetrievedFromTheDatabaseAndPublishedByCombineOnInitialisation() throws {
        /*
         Given a FakeRepository and a blank in-memory database, each data entry will have a different date
         starting at "1900-01-01" and ending at "1900-01-{amountOfDatabaseEntries}".
         e.g. When there are 15 items, each item will have a date starting at 1900-01-01 and ending at
         1900-01-15.
         */
        let amountOfDatabaseEntries = 17
        sut.multipleUniqueDataItemsReceived = true
        sut.amountOfUniqueItemsReceived = amountOfDatabaseEntries
        let newVaccExpectation = XCTestExpectation(description: "Retrieve new vaccination data from database via Publisher.")
        let cumVaccExpectation = XCTestExpectation(description: "Retrieve cumulative vaccination data from database via Publisher.")
        let uptakePercentageExpectation = XCTestExpectation(description: "Retrieve uptake percentage data from database via Publisher.")
        
        // When the data is refreshed.
        sut.newDataReceived = true
        sut.refreshVaccinationData()
        
        // Then the latest data entry from the CoreData database should be published using Combine.
        let cancellables = getCancellables(newVaccExpectation: newVaccExpectation, cumVaccExpectation: cumVaccExpectation, uptakePercentageExpectation: uptakePercentageExpectation)
        
        wait(for: [newVaccExpectation], timeout: 10)
        wait(for: [cumVaccExpectation], timeout: 10)
        wait(for: [uptakePercentageExpectation], timeout: 10)
        
        let expectedDateAsString = ResponseDTO.retrieveUniqueResponseData(amountOfItems: amountOfDatabaseEntries).data?.last?.date
        let expectedDateAsDate = transformStringIntoDate(dateAsString: expectedDateAsString!)
        
        XCTAssert(newVaccinations.date == expectedDateAsDate)
        
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
    
    private func verifyEntitiesConvertedToDomainObjects(newVaccinations: NewVaccinationsDomainObject,
                                                cumVaccinations: CumulativeVaccinationsDomainObject,
                                                uptakePercentages: UptakePercentageDomainObject,
                                                newDataReceived: Bool) {
        let items: Int
        if newDataReceived {
            items = 8
        } else {
            items = 4
        }
        
        // If we receive new data, use the unique response date, otherwise use the non-unique response.
        let expectedDateAsString = newDataReceived ?
            ResponseDTO.retrieveUniqueResponseData(amountOfItems: items).data?.last?.date :
            ResponseDTO.retrieveResponseData(amountOfItems: items).data?.last?.date
        let expectedDateAsDate = transformStringIntoDate(dateAsString: expectedDateAsString!)
        let expectedCountry = ResponseDTO.retrieveUniqueResponseData(amountOfItems: items).data?.last?.areaName
        let expectedNewVaccinations = ResponseDTO.retrieveUniqueResponseData(amountOfItems: items).data?.last?.newPeopleWithThirdDose
        let expectedCumVaccinations = ResponseDTO.retrieveUniqueResponseData(amountOfItems: items).data?.last?.cumulativeThirdDoses
        let expectedThirdVaccinations = ResponseDTO.retrieveUniqueResponseData(amountOfItems: items).data?.last?.thirdDoseUptakePercentage
        
        XCTAssert(newVaccinations.date == expectedDateAsDate)
        XCTAssert(newVaccinations.country! == expectedCountry)
        XCTAssert(newVaccinations.newVaccinations == expectedNewVaccinations)
        XCTAssert(cumVaccinations.date == expectedDateAsDate)
        XCTAssert(cumVaccinations.country! == expectedCountry)
        XCTAssert(cumVaccinations.cumulativeVaccinations == expectedCumVaccinations)
        XCTAssert(uptakePercentages.date == expectedDateAsDate)
        XCTAssert(uptakePercentages.country! == expectedCountry)
        XCTAssert(uptakePercentages.thirdDoseUptakePercentage == Int(expectedThirdVaccinations!))
    }
    
    private func getCancellables(newVaccExpectation: XCTestExpectation,
                                 cumVaccExpectation: XCTestExpectation,
                                 uptakePercentageExpectation: XCTestExpectation) -> Set<AnyCancellable> {
        
        return [
            isNewVaccinationsPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] in
                    self?.newVaccinations = $0
                    newVaccExpectation.fulfill()
                },
            isCumVaccinationsPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] in
                    self?.cumVaccinations = $0
                    cumVaccExpectation.fulfill()
                },
            isUptakePercentagesPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] in
                    self?.uptakePercentages = $0
                    uptakePercentageExpectation.fulfill()
                }]
    }
}
