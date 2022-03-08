//
//  FakeRepository.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 04/03/2022.
//

import Foundation
@testable import Asclepione

class FakeRepository: RepositoryProtocol {
    var networkError = false
    var responseData: ResponseDTO? = nil
    
    var newVaccinationsEntities: [MockNewVaccinations] = []
    var cumulativeVaccinationsEntities: [MockCumulativeVaccinations] = []
    var uptakePercentages: [MockUptakePercentages] = []
    
    func refreshVaccinationData() {
        // TODO: This could be a Combine response.
        if networkError == true {
            print("There was a network error.")
        } else {
            responseData = ResponseDTO.retrieveResponseData(amountOfItems: 4)
            convertDTOtoEntities(dto: responseData!)
        }
    }
    
    private func convertDTOtoEntities(dto: ResponseDTO) {
        let unwrappedDTO = unwrapDTO(dtoToUnwrap: dto)
        let latestNewVaccinations = convertDTOtoNewVaccinations(unwrappedDTO: unwrappedDTO)
        let latestCumulativeVaccinations = convertDTOtoCumulativeVaccinations(unwrappedDTO: unwrappedDTO)
        let latestUptakePercentages = convertDTOtoUptakePercentages(unwrappedDTO: unwrappedDTO)
        insertResultsIntoLocalDatabase(latestNewVaccinations, latestCumulativeVaccinations, latestUptakePercentages)
    }
    
    private func insertResultsIntoLocalDatabase(_ latestNewVaccinations: [MockNewVaccinations],
                                                _ latestCumulativeVaccinations: [MockCumulativeVaccinations],
                                                _ latestUptakePercentages: [MockUptakePercentages]) {
        newVaccinationsEntities = latestNewVaccinations
        cumulativeVaccinationsEntities = latestCumulativeVaccinations
        uptakePercentages = latestUptakePercentages
    }
    
    private func convertDTOtoNewVaccinations(unwrappedDTO: [VaccinationDataDTO]) -> [MockNewVaccinations] {
        return unwrappedDTO.map {
            let vaccination = MockNewVaccinations()
            vaccination.id = createReproducibleUniqueID(date: $0.date, areaName: $0.areaName)
            vaccination.areaName = $0.areaName
            vaccination.date = transformStringIntoDate(dateAsString: $0.date)
            vaccination.newFirstDoses = Int16($0.newPeopleWithFirstDose!)
            vaccination.newSecondDoses = Int16($0.newPeopleWithSecondDose!)
            vaccination.newThirdDoses = Int16($0.newPeopleWithThirdDose!)
            vaccination.newVaccinations = Int16($0.newVaccinations!)
            return vaccination
        }
    }
    
    private func convertDTOtoCumulativeVaccinations(unwrappedDTO: [VaccinationDataDTO]) -> [MockCumulativeVaccinations] {
        return unwrappedDTO.map {
            let vaccination = MockCumulativeVaccinations()
            vaccination.id = createReproducibleUniqueID(date: $0.date, areaName: $0.areaName)
            vaccination.areaName = $0.areaName
            vaccination.date = transformStringIntoDate(dateAsString: $0.date)
            vaccination.cumulativeFirstDoses = Int16($0.cumulativeFirstDoses!)
            vaccination.cumulativeSecondDoses = Int16($0.cumulativeSecondDoses!)
            vaccination.cumulativeThirdDoses = Int16($0.cumulativeThirdDoses!)
            vaccination.cumulativeVaccinations = Int16($0.cumulativeVaccinations!)
            return vaccination
        }
    }
    
    private func convertDTOtoUptakePercentages(unwrappedDTO: [VaccinationDataDTO]) -> [MockUptakePercentages] {
        return unwrappedDTO.map {
            let vaccination = MockUptakePercentages()
            vaccination.id = createReproducibleUniqueID(date: $0.date, areaName: $0.areaName)
            vaccination.areaName = $0.areaName
            vaccination.date = transformStringIntoDate(dateAsString: $0.date)
            vaccination.firstDoseUptakePercentage = $0.firstDoseUptakePercentage!
            vaccination.secondDoseUptakePercentage = $0.secondDoseUptakePercentage!
            vaccination.thirdDoseUptakePercentage = $0.thirdDoseUptakePercentage!
            return vaccination
        }
    }
    
}
