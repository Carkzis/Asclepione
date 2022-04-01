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
    
    // TODO: Other countries in UK to be added later.
    @Published var newVaccinationsEngland: NewVaccinationsDomainObject = NewVaccinationsDomainObject(country: nil, date: nil, newVaccinations: nil)
    @Published var cumVaccinationsEngland: [CumulativeVaccinationsDomainObject] = []
    @Published var uptakePercentagesEngland: [UptakePercentageDomainObject] = []
    
    func refreshVaccinationData() {
        // This will grab fake data and convert it into entities.
        let mockData: ResponseDTO!
        if (multipleUniqueDataItemsReceived) {
            mockData = ResponseDTO.retrieveUniqueResponseData(amountOfItems: 4)
        } else {
            mockData = ResponseDTO.retrieveResponseData(amountOfItems: 4)
        }
        repositoryUtils.convertDTOToEntities(dto: mockData)
        
        // TODO: Grab the data from the database here. This grab will occur on initialisation too in reality.
        retrieveEntitiesAndConvertToDomainObjects()
    }
    
    private func retrieveEntitiesAndConvertToDomainObjects() {
        retrieveNewVaccinationEntitiesAndConvertToDomainObjects()
        
//        let cumVaccinationsFetchRequest = NSFetchRequest<CumulativeVaccinations>(entityName: CumulativeVaccinations.entityName)
//        let percentagesFetchRequest = NSFetchRequest<UptakePercentages>(entityName: UptakePercentages.entityName)
        
    }
    
    private func retrieveNewVaccinationEntitiesAndConvertToDomainObjects() {
        let newVaccinationsFetchRequest = NSFetchRequest<NewVaccinations>(entityName: NewVaccinations.entityName)
        let sortDescriptor = NSSortDescriptor(key: #keyPath(NewVaccinations.date), ascending: true)
        newVaccinationsFetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let newVaccinationsData = try self.repositoryUtils
                .persistenceContainer
                .viewContext
                .fetch(newVaccinationsFetchRequest)
                .map { entity in
                    NewVaccinationsDomainObject(country: entity.areaName!, date: entity.date!, newVaccinations: Int(entity.newThirdDoses))
                }[0]
            newVaccinationsEngland = newVaccinationsData
        } catch {
            print("Something went wrong fetching vaccination data: \(error)")
        }
        print("SEE HERE!")
        print(newVaccinationsEngland)
    }
    
    init() {
        _ = PersistenceController(inMemory: true)
        let persistenceContainer = PersistenceController.shared.container
        self.repositoryUtils = RepositoryUtils(persistenceContainer: persistenceContainer)
        refreshVaccinationData()
    }
    
}
