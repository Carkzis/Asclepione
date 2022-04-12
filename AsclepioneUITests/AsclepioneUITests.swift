//
//  AsclepioneUITests.swift
//  AsclepioneUITests
//
//  Created by Marc Jowett on 08/02/2022.
//

import XCTest

class AsclepioneUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testContentScreenItemsExist() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Assert that we have the correct results.
        XCTAssert(app.staticTexts["titleText"].exists)
        XCTAssert(app.staticTexts["subtitleText"].exists)
        XCTAssert(app.staticTexts["countryText"].exists)
        XCTAssert(app.staticTexts["countryData"].exists)
        XCTAssert(app.staticTexts["dateText"].exists)
        XCTAssert(app.staticTexts["dateData"].exists)
        XCTAssert(app.staticTexts["newVaccText"].exists)
        XCTAssert(app.staticTexts["newVaccData"].exists)
        XCTAssert(app.staticTexts["cumVaccText"].exists)
        XCTAssert(app.staticTexts["cumVaccData"].exists)
        XCTAssert(app.staticTexts["uptakePercentageText"].exists)
        XCTAssert(app.staticTexts["uptakePercentageData"].exists)
        XCTAssert(app.buttons["refreshButton"].exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
