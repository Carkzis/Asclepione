//
//  FakeRepository.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 08/03/2022.
//

import Foundation
@testable import Asclepione
import CoreData

/*
 This is a fake repository class that uses the actual CoreData database.
 */
class FakeRepository: RepositoryProtocol {
    
    let repositoryUtils: RepositoryUtils!
    var multipleUniqueDataItemsReceived = false
    var newDataReceived = false
    
    @Published var newVaccinationsEngland: NewVaccinationsDomainObject = NewVaccinationsDomainObject(country: nil, date: nil, newVaccinations: nil)
    @Published var cumVaccinationsEngland: CumulativeVaccinationsDomainObject = CumulativeVaccinationsDomainObject(country: nil, date: nil, cumulativeVaccinations: nil)
    @Published var uptakePercentagesEngland: UptakePercentageDomainObject = UptakePercentageDomainObject(country: nil, date: nil, thirdDoseUptakePercentage: nil)
    
    func refreshVaccinationData() {
        // This will grab fake data and convert it into entities.
        let mockData: ResponseDTO!
        if (multipleUniqueDataItemsReceived) {
            if (newDataReceived) {
                mockData = ResponseDTO.retrieveUniqueResponseData(amountOfItems: 8)
            } else {
                mockData = ResponseDTO.retrieveUniqueResponseData(amountOfItems: 4)
            }
        } else {
            mockData = ResponseDTO.retrieveResponseData(amountOfItems: 4)
        }
        repositoryUtils.convertDTOToEntities(dto: mockData)
        
        let latestDatabaseEntities = repositoryUtils.retrieveEntitiesAndConvertToDomainObjects()
        newVaccinationsEngland = latestDatabaseEntities.newVaccinationsEngland
        cumVaccinationsEngland = latestDatabaseEntities.cumVaccinationsEngland
        uptakePercentagesEngland = latestDatabaseEntities.uptakePercentagesEngland
    }
    

    
    init() {
        _ = PersistenceController(inMemory: true)
        let persistenceContainer = PersistenceController.shared.container
        self.repositoryUtils = RepositoryUtils(persistenceContainer: persistenceContainer)
        refreshVaccinationData()
    }
    
}
