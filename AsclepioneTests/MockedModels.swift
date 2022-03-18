//
//  MockModelProvider.swift
//  Asclepione
//
//  Created by Marc Jowett on 14/02/2022.
//

import Foundation
@testable import Asclepione

extension ResponseDTO {
    static func retrieveResponseData(amountOfItems: Int) -> ResponseDTO {
        let mockVaccinationData = VaccinationDataDTO.retrieveMockVaccinationDataItem()
        let vaccinationDataArray = Array(repeating: mockVaccinationData, count: amountOfItems)
        let wrappedData = ResponseDTO(data: vaccinationDataArray)
        return wrappedData
    }
    
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
    static func retrieveMockVaccinationDataItem() -> VaccinationDataDTO {
        let mockDate = "1900-01-01"
        let mockRegion = "England"
        return VaccinationDataDTO(date: mockDate, areaName: mockRegion, newPeopleWithFirstDose: 100, newPeopleWithSecondDose: 100, newPeopleWithThirdDose: 100, newVaccinations: 300, cumulativeFirstDoses: 1000, cumulativeSecondDoses: 1000, cumulativeThirdDoses: 1000, cumulativeVaccinations: 3000, firstDoseUptakePercentage: 10, secondDoseUptakePercentage: 10, thirdDoseUptakePercentage: 10)
    }
    
    static func retrieveUniqueMockVaccinationDataItem(_ uniqueIdentifier: Int) -> VaccinationDataDTO {
        let mockDate = "1900-01-01"
        let mockRegion = "England\(uniqueIdentifier)"
        return VaccinationDataDTO(date: mockDate, areaName: mockRegion, newPeopleWithFirstDose: 100, newPeopleWithSecondDose: 100, newPeopleWithThirdDose: 100, newVaccinations: 300, cumulativeFirstDoses: 1000, cumulativeSecondDoses: 1000, cumulativeThirdDoses: 1000, cumulativeVaccinations: 3000, firstDoseUptakePercentage: 10, secondDoseUptakePercentage: 10, thirdDoseUptakePercentage: 10)
    }
}
