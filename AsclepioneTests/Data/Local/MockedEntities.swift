//
//  MockedEntities.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 04/03/2022.
//

import Foundation
@testable import Asclepione

/**
 These are for unit testing that DTOs are correctly translated into their respective entities.
 */

class MockNewVaccinations: NewVaccinationsEntity {
    public var areaName: String?
    public var date: Date?
    public var id: String?
    public var newFirstDoses: Int32 = 0
    public var newSecondDoses: Int32 = 0
    public var newThirdDoses: Int32 = 0
    public var newVaccinations: Int32 = 0
}

class MockUptakePercentages: UptakePercentagesEntity {
    public var areaName: String?
    public var date: Date?
    public var firstDoseUptakePercentage: Float =  0.0
    public var id: String?
    public var secondDoseUptakePercentage: Float = 0.0
    public var thirdDoseUptakePercentage: Float = 0.0
}

class MockCumulativeVaccinations: CumulativeVaccinationsEntity {
    public var areaName: String?
    public var cumulativeFirstDoses: Int32 = 0
    public var cumulativeSecondDoses: Int32 = 0
    public var cumulativeThirdDoses: Int32 = 0
    public var date: Date?
    public var id: String?
    public var cumulativeVaccinations: Int32 = 0
}
