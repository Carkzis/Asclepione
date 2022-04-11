//
//  MockModelProvider.swift
//  Asclepione
//
//  Created by Marc Jowett on 14/02/2022.
//

import Foundation
@testable import Asclepione

extension ResponseDTO {
    /**
     Retrieves a set amount of duplicate mock response data held within a ResponseDTO wrapper.
     */
    static func retrieveResponseData(amountOfItems: Int) -> ResponseDTO {
        let mockVaccinationData = VaccinationDataDTO.retrieveMockVaccinationDataItem()
        let vaccinationDataArray = Array(repeating: mockVaccinationData, count: amountOfItems)
        let wrappedData = ResponseDTO(data: vaccinationDataArray)
        return wrappedData
    }
    
    /**
     Retrieves unique mock response data, where the region will be treated as the unique identifier,
     held within a ResponseDTO wrapper.
     The day of the date will increase between 1 to 28, after which the date will stay at 1900-01-28,
     but the date will stay the same after this and the retrieved response items will no longer be unique.
     */
    static func retrieveUniqueResponseData(amountOfItems: Int) -> ResponseDTO {
        var uniqueDataArray: [VaccinationDataDTO] = []
        for i in 1...amountOfItems {
            let mockItem = VaccinationDataDTO.retrieveUniqueMockVaccinationDataItem(i)
            uniqueDataArray.append(mockItem)
        }
        let wrappedData = ResponseDTO(data: uniqueDataArray)
        return wrappedData
    }
}

extension VaccinationDataDTO {
    /**
     Retrieves mock vaccination data.
     */
    static func retrieveMockVaccinationDataItem() -> VaccinationDataDTO {
        let mockDate = "1900-01-01"
        let mockRegion = "England"
        return VaccinationDataDTO(date: mockDate, areaName: mockRegion, newPeopleWithFirstDose: 100, newPeopleWithSecondDose: 100, newPeopleWithThirdDose: 100, newVaccinations: 300, cumulativeFirstDoses: 1000, cumulativeSecondDoses: 1000, cumulativeThirdDoses: 1000, cumulativeVaccinations: 3000, firstDoseUptakePercentage: 10, secondDoseUptakePercentage: 10, thirdDoseUptakePercentage: 10)
    }
    
    /**
     Retrieves unique mock vaccination data, where the region will be treated as the unique identifier.
     The day of the date will increase between 1 to 28, after which the date will stay at 1900-01-28,
     but the date will stay the same after this and the retrieved response items will no longer be unique.
     */
    static func retrieveUniqueMockVaccinationDataItem(_ uniqueIdentifier: Int) -> VaccinationDataDTO {
        // Ensure day of date increases up to 28 days.
        var mockDate = uniqueIdentifier < 10 ? "1900-01-0\(uniqueIdentifier)" : "1900-01-\(uniqueIdentifier)"
        mockDate = uniqueIdentifier > 28 ? "1900-01-28" : mockDate
        let mockRegion = "England"
        return VaccinationDataDTO(date: mockDate, areaName: mockRegion, newPeopleWithFirstDose: 100, newPeopleWithSecondDose: 100, newPeopleWithThirdDose: 100, newVaccinations: 300, cumulativeFirstDoses: 1000, cumulativeSecondDoses: 1000, cumulativeThirdDoses: 1000, cumulativeVaccinations: 3000, firstDoseUptakePercentage: 10, secondDoseUptakePercentage: 10, thirdDoseUptakePercentage: 10)
    }
}
