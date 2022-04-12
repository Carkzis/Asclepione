//
//  AsclepioneUITests.swift
//  AsclepioneUITests
//
//  Created by Marc Jowett on 08/02/2022.
//

import XCTest
import Foundation

@testable import Asclepione

class AsclepioneUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
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
    
    func testDataDisplayingInCorrectFormat() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Assert that all the data fields will variable values are correctly formatted.
        assertCountryDataFormatCorrect(app: app)
        assertDateDataFormatCorrect(app: app)
        assertVaccinationAmountDataFormatCorrect(app: app, amountType: "newVaccData")
        assertVaccinationAmountDataFormatCorrect(app: app, amountType: "cumVaccData")
        assertUptakePercentageDataFormatCorrect(app: app)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func assertCountryDataFormatCorrect(app: XCUIApplication) {
        let countryData = app.staticTexts["countryData"].label
        XCTAssert(countryData == "???" ||
                  countryData == "England" ||
                  countryData == "Wales" ||
                  countryData == "Scotland" ||
                  countryData == "Northern Ireland")
    }
    
    func assertDateDataFormatCorrect(app: XCUIApplication) {
        let dateData = app.staticTexts["dateData"].label
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_UK")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let dateStringAsDate: Date!
        if let date = dateFormatter.date(from: dateData) {
            dateStringAsDate = date
        } else {
            let defaultDate = "01-01-1900"
            dateStringAsDate = dateFormatter.date(from: defaultDate)!
        }

        /*
        The "failed" date would be "1900-01-01", generated by the DateFormatter if it gets a value in the format,
        which we should not expect from UI tests with the exception of "???", which is permissable as a placeholder.
        */
        let failedDatePlaceholder = dateFormatter.date(from: "01-01-1900")
        XCTAssert(dateStringAsDate != failedDatePlaceholder || dateData == "???")
    }
    
    func assertVaccinationAmountDataFormatCorrect(app: XCUIApplication, amountType: String) {
        let vaccData = app.staticTexts[amountType].label
        let vaccDataWithoutCommas = vaccData.replacingOccurrences(of: ",", with: "")
        let dataAsInt = Int(vaccDataWithoutCommas)
        if let data = dataAsInt {
            XCTAssertTrue(data >= 0)
        } else {
            XCTFail("Cannot convert provided \(amountType) String to Int.")
        }
    }
    
    func assertUptakePercentageDataFormatCorrect(app: XCUIApplication) {
        let uptakePercentage = app.staticTexts["uptakePercentageData"].label
        XCTAssert(uptakePercentage.last == "%")
        let secondLastIndex = uptakePercentage.index(uptakePercentage.endIndex, offsetBy: -1)
        let uptakePercentageLessPercentSign = uptakePercentage[..<secondLastIndex]
        let percentageAsInt = Int(uptakePercentageLessPercentSign)
        if let percentage = percentageAsInt {
            XCTAssertTrue(percentage >= 0 && percentage <= 100)
        } else {
            XCTFail("Cannot convert provided uptake percentage String to Int.")
        }
    }
}
