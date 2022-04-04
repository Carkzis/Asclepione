//
//  FakeRepository.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 04/03/2022.
//

import Foundation
@testable import Asclepione
import Combine

/*
 This is a mock repository that uses lists to hold mock data, used to test data transformation of remote data
 objects into mock database entities.
 */
class MockRepository: Repository {
    /*
     Not used in implementation.
     */
    @Published var newVaccinationsEngland: NewVaccinationsDomainObject = NewVaccinationsDomainObject(country: nil, date: nil, newVaccinations: nil)
    @Published var cumVaccinationsEngland: CumulativeVaccinationsDomainObject = CumulativeVaccinationsDomainObject(country: nil, date: nil, cumulativeVaccinations: nil)
    @Published var uptakePercentagesEngland: UptakePercentageDomainObject = UptakePercentageDomainObject(country: nil, date: nil, thirdDoseUptakePercentage: nil)
    var newVaccinationsEnglandPublisher: Published<NewVaccinationsDomainObject>.Publisher { $newVaccinationsEngland }
    var cumVaccinationsEnglandPublisher: Published<CumulativeVaccinationsDomainObject>.Publisher { $cumVaccinationsEngland }
    var uptakePercentagesEnglandPublisher: Published<UptakePercentageDomainObject>.Publisher { $uptakePercentagesEngland }
    
    var networkError = false
    var responseData: ResponseDTO? = nil
    
    var newVaccinationsEntities: [NewVaccinationsEntity] = []
    var cumulativeVaccinationsEntities: [CumulativeVaccinationsEntity] = []
    var uptakePercentages: [UptakePercentagesEntity] = []
    
    func refreshVaccinationData() {
        if networkError == true {
            print("There was a network error.")
        } else {
            responseData = ResponseDTO.retrieveResponseData(amountOfItems: 4)
            convertDTOToEntities(dto: responseData!)
        }
    }
    
    private func convertDTOToEntities(dto: ResponseDTO) {
        let unwrappedDTO = unwrapDTO(dtoToUnwrap: dto)
        let latestNewVaccinations = convertDTOToNewVaccinations(unwrappedDTO: unwrappedDTO)
        let latestCumulativeVaccinations = convertDTOToCumulativeVaccinations(unwrappedDTO: unwrappedDTO)
        let latestUptakePercentages = convertDTOToUptakePercentages(unwrappedDTO: unwrappedDTO)
        insertResultsIntoLocalDatabase(latestNewVaccinations, latestCumulativeVaccinations, latestUptakePercentages)
    }
    
    private func insertResultsIntoLocalDatabase(_ latestNewVaccinations: [NewVaccinationsEntity],
                                                _ latestCumulativeVaccinations: [CumulativeVaccinationsEntity],
                                                _ latestUptakePercentages: [UptakePercentagesEntity]) {
        newVaccinationsEntities = latestNewVaccinations
        cumulativeVaccinationsEntities = latestCumulativeVaccinations
        uptakePercentages = latestUptakePercentages
    }
    
    private func convertDTOToNewVaccinations(unwrappedDTO: [VaccinationDataDTO]) -> [NewVaccinationsEntity] {
        return unwrappedDTO.map {
            let vaccination = MockNewVaccinations()
            vaccination.id = createReproducibleUniqueID(date: $0.date, areaName: $0.areaName)
            vaccination.areaName = $0.areaName
            vaccination.date = transformStringIntoDate(dateAsString: $0.date)
            vaccination.newFirstDoses = Int32($0.newPeopleWithFirstDose!)
            vaccination.newSecondDoses = Int32($0.newPeopleWithSecondDose!)
            vaccination.newThirdDoses = Int32($0.newPeopleWithThirdDose!)
            vaccination.newVaccinations = Int32($0.newVaccinations!)
            return vaccination
        }
    }
    
    private func convertDTOToCumulativeVaccinations(unwrappedDTO: [VaccinationDataDTO]) -> [CumulativeVaccinationsEntity] {
        return unwrappedDTO.map {
            let vaccination = MockCumulativeVaccinations()
            vaccination.id = createReproducibleUniqueID(date: $0.date, areaName: $0.areaName)
            vaccination.areaName = $0.areaName
            vaccination.date = transformStringIntoDate(dateAsString: $0.date)
            vaccination.cumulativeFirstDoses = Int32($0.cumulativeFirstDoses!)
            vaccination.cumulativeSecondDoses = Int32($0.cumulativeSecondDoses!)
            vaccination.cumulativeThirdDoses = Int32($0.cumulativeThirdDoses!)
            vaccination.cumulativeVaccinations = Int32($0.cumulativeVaccinations!)
            return vaccination
        }
    }
    
    private func convertDTOToUptakePercentages(unwrappedDTO: [VaccinationDataDTO]) -> [UptakePercentagesEntity] {
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
