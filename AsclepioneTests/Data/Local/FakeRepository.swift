//
//  FakeRepository.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 08/03/2022.
//

import Foundation
@testable import Asclepione
import CoreData

/**
 This is a fake repository class that uses the actual CoreData database.
 */
class FakeRepository: Repository {
    
    let repositoryUtils: RepositoryUtils!
    var multipleUniqueDataItemsReceived = false
    var newDataReceived = false
    var amountOfUniqueItemsReceived = 8
    
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
     Imitates refreshing data, but obtaining mock data wrapped in a ResponseDTO, and either retrieve duplicate data,
     unique data of a set amount of 4 if it is called on initialisation of the repository, and a unique data of a provided
     amount with a minimum of 5.
     This is so that the second refresh will always have more recently dated data for comparisons sake when testing.
     */
    func refreshVaccinationData() {
        // This will grab mock data and convert it into entities.
        isLoading = true // Mock that we are loading from REST API.
        let mockData: ResponseDTO!
        if (multipleUniqueDataItemsReceived) {
            if (newDataReceived) {
                let uniqueItemsReceivedButMin5 = amountOfUniqueItemsReceived > 5 ? amountOfUniqueItemsReceived : 5
                mockData = ResponseDTO.retrieveUniqueResponseData(amountOfItems: uniqueItemsReceivedButMin5)
            } else {
                mockData = ResponseDTO.retrieveUniqueResponseData(amountOfItems: 4)
                newDataReceived = true
            }
        } else {
            mockData = ResponseDTO.retrieveResponseData(amountOfItems: 4)
        }
        isLoading = false // Mock that loading from REST API has finished.
        repositoryUtils.convertDTOToEntities(dto: mockData)
        
        /*
         NOTE: These could potentially end up out of sync, date wise, as they are held in different tables.
         This should be an unlikely occurance, that is rectified the next time the tables are updated.
         This is preferable to raising an exception.
         */
        let latestDatabaseEntities = repositoryUtils.retrieveEntitiesAndConvertToDomainObjects()
        newVaccinations = latestDatabaseEntities.newVaccinations
        cumVaccinations = latestDatabaseEntities.cumVaccinations
        uptakePercentages = latestDatabaseEntities.uptakePercentages
    }
    
    init() {
        _ = PersistenceController(inMemory: true)
        let persistenceContainer = PersistenceController.shared.container
        self.repositoryUtils = RepositoryUtils(persistenceContainer: persistenceContainer)
        refreshVaccinationData()
    }
    
}
