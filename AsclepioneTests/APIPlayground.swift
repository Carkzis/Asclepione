//
//  APIPlayground.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 23/02/2022.
//

import XCTest
@testable import Alamofire
@testable import Asclepione

class APIPlayground: XCTestCase {
    
    /**
     Note: This requires an internet connection.  Queries vaccination data from https://api.coronavirus.data.gov.uk/v1/data.
     */
    
    private var sut: ServiceAPIProtocol!

    override func setUpWithError() throws {
        sut = CoronavirusServiceAPI()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testThatASuccessfulAPIResponseIsReceivedOverInternet() throws {
        // Given a succesful response.
        let expectation = XCTestExpectation(description: "Perform a request to the fake API.")
        
        // When we get a result from the API.
        let cancellable = sut.retrieveFromWebAPI().sink { (dataResponse) in
            if dataResponse.error == nil {
                print(dataResponse.value!)
                XCTAssertTrue(dataResponse.result.isSuccess)
                if let vaccinationData = dataResponse.value?.data {
                    XCTAssertTrue(!vaccinationData.isEmpty)
                }
                expectation.fulfill()
            }
        }
        
        // Then, we get a succesful response after a few seconds containing vaccination data.
        wait(for: [expectation], timeout: 10)
        cancellable.cancel() // This is just to silence the warning.
    }


}
