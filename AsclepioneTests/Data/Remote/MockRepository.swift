//
//  FakeRepository.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 04/03/2022.
//

import Foundation
@testable import Asclepione
import Combine

/**
 This is a mock repository that uses lists to hold mock data, used to test data transformation of remote data
 objects into mock database entities.
 */
class MockRepository: Repository {
    
    var networkError = false
    var emptyDatabase = false
    var responseData: ResponseDTO? = nil
    var newVaccinationsEntities: [NewVaccinationsEntity] = []
    var cumulativeVaccinationsEntities: [CumulativeVaccinationsEntity] = []
    var uptakePercentagesEntities: [UptakePercentagesEntity] = []
    
    /*
     Publishers.
     */
    @Published var newVaccinations: NewVaccinationsDomainObject = NewVaccinationsDomainObject(country: nil, date: nil, newVaccinations: nil)
    @Published var cumVaccinations: CumulativeVaccinationsDomainObject = CumulativeVaccinationsDomainObject(country: nil, date: nil, cumulativeVaccinations: nil)
    @Published var uptakePercentages: UptakePercentageDomainObject = UptakePercentageDomainObject(country: nil, date: nil, thirdDoseUptakePercentage: nil)
    @Published var isLoading: Bool = false
    var newVaccinationsPublisher: Published<NewVaccinationsDomainObject>.Publisher { $newVaccinations }
    var cumVaccinationsPublisher: Published<CumulativeVaccinationsDomainObject>.Publisher { $cumVaccinations }
    var uptakePercentagesPublisher: Published<UptakePercentageDomainObject>.Publisher { $uptakePercentages }
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    
    /**
     Mocks refreshing data, including the publishing of network status.
     Does not provide data if the networkError flag is set to true.
     Publishes domain objects with nil parameters if the emptyDatabase flag is set to true.
     Adds mock data to the responseData public variable in other cases.
     */
    func refreshVaccinationData() {
        isLoading = true
        if networkError == true {
            print("There was a network error.")
            isLoading = false
        } else if emptyDatabase == true {
            print("The database is empty.")
            newVaccinations = NewVaccinationsDomainObject(country: nil, date: nil, newVaccinations: nil)
            cumVaccinations = CumulativeVaccinationsDomainObject(country: nil, date: nil, cumulativeVaccinations: nil)
            uptakePercentages = UptakePercentageDomainObject(country: nil, date: nil, thirdDoseUptakePercentage: nil)
        } else {
            responseData = ResponseDTO.retrieveResponseData(amountOfItems: 4)
            convertDTOToEntities(dto: responseData!)
            isLoading = false
        }
    }
    
    /**
     Unwraps a ResponseDTO containing mock data, and converts the data into mock NewVaccinations,
     CumulativeVaccinanations and UptakePercentages entities.
     */
    private func convertDTOToEntities(dto: ResponseDTO) {
        let unwrappedDTO = unwrapDTO(dtoToUnwrap: dto)
        let latestNewVaccinations = convertDTOToNewVaccinations(unwrappedDTO: unwrappedDTO)
        let latestCumulativeVaccinations = convertDTOToCumulativeVaccinations(unwrappedDTO: unwrappedDTO)
        let latestUptakePercentages = convertDTOToUptakePercentages(unwrappedDTO: unwrappedDTO)
        insertResultsIntoLocalDatabase(latestNewVaccinations, latestCumulativeVaccinations, latestUptakePercentages)
    }
    
    /**
     Creates mock NewVaccinations entities from the mock vaccination data obtained provided.
     */
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
    
    /**
     Creates mock CumulativeVaccinations entities from the mock vaccination data obtained provided.
     */
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
    
    /**
     Creates mock UptakePercentage entities from the mock vaccination data obtained provided.
     */
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
    
    /**
     Mocks saving the results into a database, by adding them to public arrays for each entity type.
     */
    private func insertResultsIntoLocalDatabase(_ latestNewVaccinations: [NewVaccinationsEntity],
                                                _ latestCumulativeVaccinations: [CumulativeVaccinationsEntity],
                                                _ latestUptakePercentages: [UptakePercentagesEntity]) {
        // Mock insertion into database using arrays instead.
        newVaccinationsEntities = latestNewVaccinations
        cumulativeVaccinationsEntities = latestCumulativeVaccinations
        uptakePercentagesEntities = latestUptakePercentages
        
        retrieveEntitiesAndConvertToDomainObjects()
    }
    
    /**
     Retrieves the entities from the public arrays imitatating a database, and converts them to a domain objects.
     These are published using Combine.
     */
    private func retrieveEntitiesAndConvertToDomainObjects() {
        newVaccinations = newVaccinationsEntities.map { entity in
            NewVaccinationsDomainObject(country: entity.areaName, date: entity.date, newVaccinations: Int(entity.newVaccinations))
        }.last ?? NewVaccinationsDomainObject(country: nil, date: nil, newVaccinations: nil)
        
        cumVaccinations = cumulativeVaccinationsEntities.map { entity in
            CumulativeVaccinationsDomainObject(country: entity.areaName, date: entity.date, cumulativeVaccinations: Int(entity.cumulativeVaccinations))
        }.last ?? CumulativeVaccinationsDomainObject(country: nil, date: nil, cumulativeVaccinations: nil)
        
        uptakePercentages = uptakePercentagesEntities.map { entity in
            UptakePercentageDomainObject(country: entity.areaName, date: entity.date, thirdDoseUptakePercentage: Int(entity.thirdDoseUptakePercentage))
        }.last ?? UptakePercentageDomainObject(country: nil, date: nil, thirdDoseUptakePercentage: nil)
    }
    
}
