//
//  RespositoryTests.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 04/03/2022.
//

import XCTest
import Combine
@testable import Asclepione
import SwiftUI

class RepositoryRemoteDataSourceTests: XCTestCase {
    
    var sut: MockRepository!
    
    /*
     Publishers.
     */
    var isLoading: Bool = false
    private var isLoadingPublisher: AnyPublisher<Bool, Never> {
        sut.isLoadingPublisher
            .eraseToAnyPublisher()
    }
    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        sut = MockRepository()
    }

    override func tearDownWithError() throws {
        sut = nil
        for cancellable in cancellables {
            cancellable.cancel()
        }
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
        XCTAssertFalse(sut.uptakePercentagesEntities.isEmpty)
        XCTAssertTrue(sut.uptakePercentagesEntities.count == 4)
        XCTAssertTrue(sut.uptakePercentagesEntities[0].firstDoseUptakePercentage == 10)
        
        // And an unique but reproducible id.
        XCTAssertTrue(sut.newVaccinationsEntities[0].id == expectedID)
        XCTAssertTrue(sut.cumulativeVaccinationsEntities[0].id == expectedID)
        XCTAssertTrue(sut.uptakePercentagesEntities[0].id == expectedID)
        
        // And the date string is correctly converted into a Date object.
        XCTAssertTrue(sut.newVaccinationsEntities[0].date!.description == "1900-01-01 00:00:00 +0000")
        XCTAssertTrue(sut.cumulativeVaccinationsEntities[0].date!.description == "1900-01-01 00:00:00 +0000")
        XCTAssertTrue(sut.uptakePercentagesEntities[0].date!.description == "1900-01-01 00:00:00 +0000")
    }
    
    func testLoadingStatePublishedAsTrueWhileLoadingThenFalseOnSuccessfulResponse() throws {
        // Given there is not a network error.
        sut.networkError = false
        
        // When a request to refresh the data via the network is called.
        let isLoadingExpectation = XCTestExpectation(description: "Informed loading is occuring via Publisher.")
        let isNotLoadingExpectation = XCTestExpectation(description: "Informed loading has stopped via Publisher.")
        var resultList: [Bool] = []
        cancellables = [isLoadingPublisher
                        .receive(on: RunLoop.main)
                        .sink { [weak self] in
                            self?.isLoading = $0
                        if $0 {
                            isLoadingExpectation.fulfill()
                        } else {
                            isNotLoadingExpectation.fulfill()
                        }
            resultList.append($0)
        }]
        sut.refreshVaccinationData()
        
        // Then we should get a stream of loading being false, then true, then false.
        wait(for: [isLoadingExpectation], timeout: 10)
        wait(for: [isNotLoadingExpectation], timeout: 10)
        XCTAssert(!resultList[0])
        XCTAssert(resultList[1])
        XCTAssert(!resultList[2])
    }
    
    func testLoadingStatePublishedAsTrueWhileLoadingThenFalseOnUnsuccessfulResponse() throws {
        // Given there is not a network error.
        sut.networkError = true
        
        // When a request to refresh the data via the network is called.
        let isLoadingExpectation = XCTestExpectation(description: "Informed loading is occuring via Publisher.")
        let isNotLoadingExpectation = XCTestExpectation(description: "Informed loading has stopped via Publisher.")
        var resultList: [Bool] = []
        cancellables = [isLoadingPublisher
                        .receive(on: RunLoop.main)
                        .sink { [weak self] in
                            self?.isLoading = $0
                        if $0 {
                            isLoadingExpectation.fulfill()
                        } else {
                            isNotLoadingExpectation.fulfill()
                        }
            resultList.append($0)
        }]
        sut.refreshVaccinationData()
        
        // Then we should get a stream of loading being false, then true, then false.
        wait(for: [isLoadingExpectation], timeout: 10)
        wait(for: [isNotLoadingExpectation], timeout: 10)
        XCTAssert(!resultList[0])
        XCTAssert(resultList[1])
        XCTAssert(!resultList[2])
    }
    
    func testLoadingStatesStillChangedOnRepeatAttemptsAtDataResponse() throws {
        // Given there is not a network error.
        sut.networkError = false
        
        // When a request to refresh the data via the network is called.
        let isLoadingExpectation = XCTestExpectation(description: "Informed loading is occuring via Publisher.")
        let isNotLoadingExpectation = XCTestExpectation(description: "Informed loading has stopped via Publisher.")
        var resultList: [Bool] = []
        cancellables = [isLoadingPublisher
                        .receive(on: RunLoop.main)
                        .sink { [weak self] in
                            self?.isLoading = $0
                        if $0 {
                            isLoadingExpectation.fulfill()
                        } else {
                            isNotLoadingExpectation.fulfill()
                        }
            resultList.append($0)
        }]
        sut.refreshVaccinationData()
        sut.refreshVaccinationData()
        
        // Then we should get a stream of loading being false, then true, then false, then true, then false.
        wait(for: [isLoadingExpectation], timeout: 10)
        wait(for: [isNotLoadingExpectation], timeout: 10)
        XCTAssert(!resultList[0])
        XCTAssert(resultList[1])
        XCTAssert(!resultList[2])
        XCTAssert(resultList[3])
        XCTAssert(!resultList[4])
    }
    
}
