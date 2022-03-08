//
//  RespositoryTests.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 04/03/2022.
//

import XCTest
@testable import Asclepione

class RepositoryTests: XCTestCase {
    
    var sut: FakeRepository!

    override func setUpWithError() throws {
        sut = FakeRepository()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testNetworkErrorResultsInNoResponseDTOBeingRetrieved() throws {
        // Given a network error.
        sut.networkError = true
        
        // When a request to refresh the data via the network is called.
        sut.refreshVaccinationData()
        
        // Then the responseDTO is nil.
        XCTAssertTrue(sut.responseData == nil)
    }
    
    func testSuccessfulResponseResultsInFourVaccinatedDataDTOBeingRetrieved() throws {
        // Given there is not a network error.
        sut.networkError = false
        
        // When a request to refresh the data via the network is called.
        sut.refreshVaccinationData()
        
        let responseCount: Int!
        if let responseDTO = sut.responseData {
            responseCount = responseDTO.data?.count
        } else {
            responseCount = 0
        }
        
        // Then the amount of VaccinationDataDTO items is 4 (for England, Wales, Scotland and Northern Ireland).
        XCTAssertTrue(responseCount == 4)
    }

    func testGenerateEntitiesWithReproducibleUniqueIdentifiersOnSuccessfulNetworkResponse() throws {
        // Given there is not a network error, and we have a unique reproducible id.
        sut.networkError = false
        let date = "1900-01-01"
        let areaName = "England"
        let expectedID = date + areaName
        
        // When a request to refresh the data via the network is called.
        sut.refreshVaccinationData()
        
        // Then we get three separate entity objects.
        XCTAssertFalse(sut.newVaccinationsEntities.isEmpty)
        XCTAssertTrue(sut.newVaccinationsEntities.count == 4)
        XCTAssertTrue(sut.newVaccinationsEntities[0].newFirstDoses == 100)
        XCTAssertFalse(sut.cumulativeVaccinationsEntities.isEmpty)
        XCTAssertTrue(sut.cumulativeVaccinationsEntities.count == 4)
        XCTAssertTrue(sut.cumulativeVaccinationsEntities[0].cumulativeFirstDoses == 1000)
        XCTAssertFalse(sut.uptakePercentages.isEmpty)
        XCTAssertTrue(sut.uptakePercentages.count == 4)
        XCTAssertTrue(sut.uptakePercentages[0].firstDoseUptakePercentage == 10)
        
        // And an unique but reproducible id.
        XCTAssertTrue(sut.newVaccinationsEntities[0].id == expectedID)
        XCTAssertTrue(sut.cumulativeVaccinationsEntities[0].id == expectedID)
        XCTAssertTrue(sut.uptakePercentages[0].id == expectedID)
        
        // And the date string is correctly converted into a Date object.
        XCTAssertTrue(sut.newVaccinationsEntities[0].date!.description == "1900-01-01 00:00:00 +0000")
        XCTAssertTrue(sut.cumulativeVaccinationsEntities[0].date!.description == "1900-01-01 00:00:00 +0000")
        XCTAssertTrue(sut.uptakePercentages[0].date!.description == "1900-01-01 00:00:00 +0000")
    }
    
    // TODO: Unit test using in-memory CoreData.
}
