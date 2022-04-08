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
    @Published var cumVaccinationsEngland: CumulativeVaccinationsDomainObject = CumulativeVaccinationsDomainObject(country: nil, date: nil, cumulativeVaccinations: nil)
    @Published var uptakePercentagesEngland: UptakePercentageDomainObject = UptakePercentageDomainObject(country: nil, date: nil, thirdDoseUptakePercentage: nil)
    
    private var isNewVaccinationsPublisher: AnyPublisher<NewVaccinationsDomainObject, Never> {
        sut.newVaccinationsEnglandPublisher
            .eraseToAnyPublisher()
    }
    private var isCumVaccinationsPublisher: AnyPublisher<CumulativeVaccinationsDomainObject, Never> {
        sut.cumVaccinationsEnglandPublisher
            .eraseToAnyPublisher()
    }
    private var isUptakePercentagesPublisher: AnyPublisher<UptakePercentageDomainObject, Never> {
        sut.uptakePercentagesEnglandPublisher
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
        verifyEntitiesConvertedToDomainObjects(newVaccinations: self.newVaccinationsEngland,
                                               cumVaccinations: self.cumVaccinationsEngland,
                                               uptakePercentages: self.uptakePercentagesEngland,
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
        
        // When the data is on refreshed.
        sut.newDataReceived = true
        sut.refreshVaccinationData()
        
        // Then the data from the CoreData database should be published using Combine.
        let cancellables = getCancellables(newVaccExpectation: newVaccExpectation, cumVaccExpectation: cumVaccExpectation, uptakePercentageExpectation: uptakePercentageExpectation)
        
        wait(for: [newVaccExpectation], timeout: 10)
        wait(for: [cumVaccExpectation], timeout: 10)
        wait(for: [uptakePercentageExpectation], timeout: 10)
        verifyEntitiesConvertedToDomainObjects(newVaccinations: self.newVaccinationsEngland,
                                               cumVaccinations: self.cumVaccinationsEngland,
                                               uptakePercentages: self.uptakePercentagesEngland,
                                               newDataReceived: true)
        
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
        
        let expectedDateAsString = ResponseDTO.retrieveUniqueResponseData(amountOfItems: items).data?.last?.date
        let expectedDateAsDate = transformStringIntoDate(dateAsString: expectedDateAsString!)
        let expectedCountry = ResponseDTO.retrieveUniqueResponseData(amountOfItems: items).data?.last?.areaName
        let expectedNewVaccinations = ResponseDTO.retrieveUniqueResponseData(amountOfItems: items).data?.last?.newPeopleWithThirdDose
        let expectedCumVaccinations = ResponseDTO.retrieveUniqueResponseData(amountOfItems: items).data?.last?.cumulativeThirdDoses
        let expectedThirdVaccinations = ResponseDTO.retrieveUniqueResponseData(amountOfItems: items).data?.last?.thirdDoseUptakePercentage
        
        XCTAssert(newVaccinations.date == expectedDateAsDate)
        XCTAssert(newVaccinations.country! + "\(items)" == expectedCountry)
        XCTAssert(newVaccinations.newVaccinations == expectedNewVaccinations)
        XCTAssert(cumVaccinations.date == expectedDateAsDate)
        XCTAssert(cumVaccinations.country! + "\(items)" == expectedCountry)
        XCTAssert(cumVaccinations.cumulativeVaccinations == expectedCumVaccinations)
        XCTAssert(uptakePercentages.date == expectedDateAsDate)
        XCTAssert(uptakePercentages.country! + "\(items)" == expectedCountry)
        XCTAssert(uptakePercentages.thirdDoseUptakePercentage == Int(expectedThirdVaccinations!))
    }
    
    private func getCancellables(newVaccExpectation: XCTestExpectation,
                                 cumVaccExpectation: XCTestExpectation,
                                 uptakePercentageExpectation: XCTestExpectation) -> Set<AnyCancellable> {
        
        return [
            isNewVaccinationsPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] in
                    self?.newVaccinationsEngland = $0
                    newVaccExpectation.fulfill()
                },
            isCumVaccinationsPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] in
                    self?.cumVaccinationsEngland = $0
                    cumVaccExpectation.fulfill()
                },
            isUptakePercentagesPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] in
                    self?.uptakePercentagesEngland = $0
                    uptakePercentageExpectation.fulfill()
                }]
    }
}
