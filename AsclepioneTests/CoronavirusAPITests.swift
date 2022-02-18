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
    
    private var sut: CoronavirusAPI!

    // Get a session configured to use the FakeURLProtocol.
    let sessionManager: Session = {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        config.protocolClasses = [FakeURLProtocol.self]
        return Session(configuration: config)
    }()
    
    override func setUpWithError() throws {
        sut = CoronavirusAPI(sessionManager: sessionManager)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testStatusCodeOf200ReturnsAStatusCodeOf200() throws {
        // Given a 200 status code.
        FakeURLProtocol.responseWithCode(code: 200)
        let expectation = XCTestExpectation(description: "Perform a request to the fake API.")
        
        // When we get a result from the mocked API.
        sut.retrieveFromWebAPI() { (result) in
            XCTAssertTrue(result .isSuccess)
            expectation.fulfill()
        }
        
        // Then, we get a 200 status code as a response after a few seconds.
        wait(for: [expectation], timeout: 3)
    }
    
    func testErrorsReturnAResponseWithErrors() throws {
        // Given that we get a response with errors.
        FakeURLProtocol.responseWithErrors()
        let expectation = XCTestExpectation(description: "Perform a request to the fake API.")
        
        // When we get a result from the mocked API.
        sut.retrieveFromWebAPI() { (result) in
            XCTAssertTrue(result .isFailure)
            expectation.fulfill()
        }
        
        // Then, we get a 200 status code as a response after a few seconds.
        wait(for: [expectation], timeout: 3)
    }

}
