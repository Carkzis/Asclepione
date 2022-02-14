//
//  MockModelProvider.swift
//  Asclepione
//
//  Created by Marc Jowett on 14/02/2022.
//

import Foundation

class MockModelProvider {
    static func retrieveMockVaccinationDataArray(amountOfItems: Int) -> [VaccinationData] {
        let mockVaccinationData = retrieveMockVaccinationDataItem()
        let vaccinationDataArray = Array(repeating: mockVaccinationData, count: amountOfItems)
        return vaccinationDataArray
    }
    
    static func retrieveMockVaccinationDataItem() -> VaccinationData {
        let mockDate = "1900-01-01"
        return VaccinationData(date: mockDate,
                                newVaccinationsData: retrieveMockNewVaccinationsData(),
                                cumulativeVaccinationData: retrieveMockCumulativeVaccinationsData(),
                                cumulativeVaccinationPercentageData: retrieveMockCumulativeVaccinationsPercentages())
    }
    
    static func retrieveMockNewVaccinationsData() -> NewVaccinationsData {
        return NewVaccinationsData(newPeopleWithFirstDose: 100, newPeopleWithSecondDose: 100, newPeopleWithThirdDose: 100, newVaccinations: 300, newPeopleFullyVaccinated: 100)
    }
    
    static func retrieveMockCumulativeVaccinationsData() -> CumulativeVaccinationsData {
        return CumulativeVaccinationsData(cumulativeFirstDoses: 1000, cumulativeSecondDoses: 1000, cumulativeThirdDoses: 1000, cumulativeVaccinations: 3000, cumulativeFullyVaccinated: 1000)
    }
    
    static func retrieveMockCumulativeVaccinationsPercentages() -> CumulativeVaccinationPercentageData {
        return CumulativeVaccinationPercentageData(firstDoseUptakePercentage: 10, secondDoseUptakePercentage: 10, thirdDoseUptakePercentage: 10, fullyVaccinatedPercentage: 10)
    }
}
