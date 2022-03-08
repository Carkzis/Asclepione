//
//  MockedEntities.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 04/03/2022.
//

import Foundation

/**
 These are for unit testing that DTOs are correctly translated into their respective entities.
 */

class MockNewVaccinations {
    public var areaName: String?
    public var date: Date?
    public var id: String?
    public var newFirstDoses: Int16 = 0
    public var newSecondDoses: Int16 = 0
    public var newThirdDoses: Int16 = 0
    public var newVaccinations: Int16 = 0
}

class MockUptakePercentages {
    public var areaName: String?
    public var date: Date?
    public var firstDoseUptakePercentage: Float =  0.0
    public var id: String?
    public var secondDoseUptakePercentage: Float = 0.0
    public var thirdDoseUptakePercentage: Float = 0.0
}

class MockCumulativeVaccinations {
    public var areaName: String?
    public var cumulativeFirstDoses: Int16 = 0
    public var cumulativeSecondDoses: Int16 = 0
    public var cumulativeThirdDoses: Int16 = 0
    public var date: Date?
    public var id: String?
    public var cumulativeVaccinations: Int16 = 0
}
