//
//  CoronavirusAPITests.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 18/02/2022.
//

import XCTest
@testable import Alamofire
@testable import Asclepione

class CoronavirusAPITests: XCTestCase {
    
    private var sut: ServiceAPIProtocol!

    // Get a session configured to use the FakeURLProtocol.
    let sessionManager: Session = {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        config.protocolClasses = [FakeURLProtocol.self]
        return Session(configuration: config)
    }()
    
    override func setUpWithError() throws {
        sut = CoronavirusServiceAPI(sessionManager: sessionManager)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testSimulatingSuccessfulNetworkCallReturnsResultSuccessStateAsTrue() throws {
        // Given a succesful response.
        FakeURLProtocol.getSuccessfulResponse()
        let expectation = XCTestExpectation(description: "Perform a request to the fake API.")
        
        // When we get a result from the mocked API.
        let cancellable = sut.retrieveFromWebAPI().sink { (dataResponse) in
            if dataResponse.error == nil {
                XCTAssertTrue(dataResponse.result.isSuccess)
                expectation.fulfill()
            }
        }
        
        // Then, we get a succesful response after a few seconds.
        wait(for: [expectation], timeout: 3)
        cancellable.cancel() // This is just to silence the warning.
    }
    
    func testSimulatingNetworkCallWithErrorsReturnsResultFailureStateAsTrue() throws {
        // Given that we simulate a network call response with errors.
        FakeURLProtocol.getResponseWithErrors()
        let expectation = XCTestExpectation(description: "Perform a request to the fake API.")
        
        // When we get a result from the mocked API.
        let cancellable = sut.retrieveFromWebAPI().sink { (dataResponse) in
            if dataResponse.error != nil {
                XCTAssertTrue(dataResponse.result.isFailure)
                expectation.fulfill()
            }
        }
        
        // Then, we get an error as a response after a few seconds.
        wait(for: [expectation], timeout: 3)
        cancellable.cancel() // This is just to silence the warning.
    }

}
