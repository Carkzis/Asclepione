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
}

extension VaccinationDataDTO {
    static func retrieveMockVaccinationDataItem() -> VaccinationDataDTO {
        let mockDate = "1900-01-01"
        return VaccinationDataDTO(mockDate,
                               NewVaccinationsDataDTO.retrieveMockNewVaccinationsData(),
                               CumulativeVaccinationsDataDTO.retrieveMockCumulativeVaccinationsData(),
                               CumulativeVaccinationPercentageDataDTO.retrieveMockCumulativeVaccinationsPercentages())
    }
}

extension NewVaccinationsDataDTO {
    static func retrieveMockNewVaccinationsData() -> NewVaccinationsDataDTO {
        return NewVaccinationsDataDTO(newPeopleWithFirstDose: 100, newPeopleWithSecondDose: 100, newPeopleWithThirdDose: 100, newVaccinations: 300, newPeopleFullyVaccinated: 100)
    }
}

extension CumulativeVaccinationsDataDTO {
    static func retrieveMockCumulativeVaccinationsData() -> CumulativeVaccinationsDataDTO {
        return CumulativeVaccinationsDataDTO(cumulativeFirstDoses: 1000, cumulativeSecondDoses: 1000, cumulativeThirdDoses: 1000, cumulativeVaccinations: 3000, cumulativeFullyVaccinated: 1000)
    }
}

extension CumulativeVaccinationPercentageDataDTO {
    static func retrieveMockCumulativeVaccinationsPercentages() -> CumulativeVaccinationPercentageDataDTO {
        return CumulativeVaccinationPercentageDataDTO(firstDoseUptakePercentage: 10, secondDoseUptakePercentage: 10, thirdDoseUptakePercentage: 10, fullyVaccinatedPercentage: 10)
    }
}
