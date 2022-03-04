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
        // Given there is not a network error.
        sut.networkError = false
        
        // When a request to refresh the data via the network is called.
        sut.refreshVaccinationData()
        
        // Then we get three separate entity objects.
        XCTAssertFalse(sut.newVaccinationsEntities.isEmpty)
    }
}
