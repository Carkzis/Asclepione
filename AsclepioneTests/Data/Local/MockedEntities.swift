//
//  MockedEntities.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 04/03/2022.
//

import Foundation
@testable import Asclepione

/*
 These are for unit testing that DTOs are correctly translated into their respective entities.
 */

/**
 Mocks the entity for the amount of new vaccinations in a day held within the CoreData database.
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

/**
 Mocks the entity for the cumulative total vaccinations on a given day held within the CoreData database.
 */
class MockCumulativeVaccinations: CumulativeVaccinationsEntity {
    public var areaName: String?
    public var cumulativeFirstDoses: Int32 = 0
    public var cumulativeSecondDoses: Int32 = 0
    public var cumulativeThirdDoses: Int32 = 0
    public var date: Date?
    public var id: String?
    public var cumulativeVaccinations: Int32 = 0
}

/**
 Mocks the entity for the vaccination uptake as a percentage of the population of an area, held within the CoreData database.
 */
class MockUptakePercentages: UptakePercentagesEntity {
    public var areaName: String?
    public var date: Date?
    public var firstDoseUptakePercentage: Float =  0.0
    public var id: String?
    public var secondDoseUptakePercentage: Float = 0.0
    public var thirdDoseUptakePercentage: Float = 0.0
}
