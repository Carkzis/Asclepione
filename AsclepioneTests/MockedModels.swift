//
//  MockModelProvider.swift
//  Asclepione
//
//  Created by Marc Jowett on 14/02/2022.
//

import Foundation
@testable import Asclepione

extension ResponseData {
    static func retrieveResponseData(amountOfItems: Int) -> ResponseData {
        let mockVaccinationData = VaccinationData.retrieveMockVaccinationDataItem()
        let vaccinationDataArray = Array(repeating: mockVaccinationData, count: amountOfItems)
        let wrappedData = ResponseData(data: vaccinationDataArray)
        return wrappedData
    }
}

extension VaccinationData {
    static func retrieveMockVaccinationDataItem() -> VaccinationData {
        let mockDate = "1900-01-01"
        return VaccinationData(mockDate,
                               NewVaccinationsData.retrieveMockNewVaccinationsData(),
                               CumulativeVaccinationsData.retrieveMockCumulativeVaccinationsData(),
                               CumulativeVaccinationPercentageData.retrieveMockCumulativeVaccinationsPercentages())
    }
}

extension NewVaccinationsData {
    static func retrieveMockNewVaccinationsData() -> NewVaccinationsData {
        return NewVaccinationsData(newPeopleWithFirstDose: 100, newPeopleWithSecondDose: 100, newPeopleWithThirdDose: 100, newVaccinations: 300, newPeopleFullyVaccinated: 100)
    }
}

extension CumulativeVaccinationsData {
    static func retrieveMockCumulativeVaccinationsData() -> CumulativeVaccinationsData {
        return CumulativeVaccinationsData(cumulativeFirstDoses: 1000, cumulativeSecondDoses: 1000, cumulativeThirdDoses: 1000, cumulativeVaccinations: 3000, cumulativeFullyVaccinated: 1000)
    }
}

extension CumulativeVaccinationPercentageData {
    static func retrieveMockCumulativeVaccinationsPercentages() -> CumulativeVaccinationPercentageData {
        return CumulativeVaccinationPercentageData(firstDoseUptakePercentage: 10, secondDoseUptakePercentage: 10, thirdDoseUptakePercentage: 10, fullyVaccinatedPercentage: 10)
    }
}
