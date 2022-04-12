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

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        app.staticTexts["Country:"].tap()
        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element(boundBy: 0).tap()
        app.staticTexts["Date:"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .textField).element(boundBy: 1).tap()
        app.staticTexts["New Vaccinations:"].tap()
        element.children(matching: .textField).element(boundBy: 2).tap()
        app.staticTexts["Cumulative Vaccinations:"].tap()
        element.children(matching: .textField).element(boundBy: 3).tap()
        app.staticTexts["Uptake Percentage:"].tap()
        element.children(matching: .textField).element(boundBy: 4).tap()
        
        let refreshDataButton = app.buttons["Refresh data?"]
        refreshDataButton.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let element2 = app.children(matching: .window).element(boundBy: 1).children(matching: .other).element
        element2.tap()
        refreshDataButton.tap()
        element2.tap()
        element2.tap()
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
