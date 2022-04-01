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
        
        retrieveEntitiesAndConvertToDomainObjects()
    }
    
    private func retrieveEntitiesAndConvertToDomainObjects() {
        retrieveNewVaccinationEntitiesAndConvertToDomainObjects()
        retrieveCumulativeVaccinationEntitiesAndConvertToDomainObjects()
        retrieveUptakePercentageEntitiesAndConvertToDomainObjects()
    }
    
    private func retrieveNewVaccinationEntitiesAndConvertToDomainObjects() {
        let newVaccinationsFetchRequest = NSFetchRequest<NewVaccinations>(entityName: NewVaccinations.entityName)
        let sortDescriptor = NSSortDescriptor(key: #keyPath(NewVaccinations.date), ascending: true)
        newVaccinationsFetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let latestNewVaccinationsData = try self.repositoryUtils
                .persistenceContainer
                .viewContext
                .fetch(newVaccinationsFetchRequest)
                .map { entity in
                    NewVaccinationsDomainObject(country: entity.areaName!, date: entity.date!, newVaccinations: Int(entity.newThirdDoses))
                }[0]
            newVaccinationsEngland = latestNewVaccinationsData
        } catch {
            print("Something went wrong fetching new vaccination data: \(error)")
        }
    }
    
    private func retrieveCumulativeVaccinationEntitiesAndConvertToDomainObjects() {
        let cumVaccinationsFetchRequest = NSFetchRequest<CumulativeVaccinations>(entityName: CumulativeVaccinations.entityName)
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CumulativeVaccinations.date), ascending: true)
        cumVaccinationsFetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let latestCumVaccinationsData = try self.repositoryUtils
                .persistenceContainer
                .viewContext
                .fetch(cumVaccinationsFetchRequest)
                .map { entity in
                    CumulativeVaccinationsDomainObject(country: entity.areaName!, date: entity.date!, cumulativeVaccinations: Int(entity.cumulativeThirdDoses))
                }[0]
            cumVaccinationsEngland = latestCumVaccinationsData
        } catch {
            print("Something went wrong fetching cumualtive vaccination data: \(error)")
        }
    }
    
    private func retrieveUptakePercentageEntitiesAndConvertToDomainObjects() {
        let uptakePercentageFetchRequest = NSFetchRequest<UptakePercentages>(entityName: UptakePercentages.entityName)
        let sortDescriptor = NSSortDescriptor(key: #keyPath(UptakePercentages.date), ascending: true)
        uptakePercentageFetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let latestUptakePercentagesData = try self.repositoryUtils
                .persistenceContainer
                .viewContext
                .fetch(uptakePercentageFetchRequest)
                .map { entity in
                    UptakePercentageDomainObject(country: entity.areaName!, date: entity.date!, thirdDoseUptakePercentage: Int(entity.thirdDoseUptakePercentage))
                }[0]
            uptakePercentagesEngland = latestUptakePercentagesData
        } catch {
            print("Something went wrong fetching uptake percentages data: \(error)")
        }
    }
    
    init() {
        _ = PersistenceController(inMemory: true)
        let persistenceContainer = PersistenceController.shared.container
        self.repositoryUtils = RepositoryUtils(persistenceContainer: persistenceContainer)
        refreshVaccinationData()
    }
    
}
