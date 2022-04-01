//
//  RepositoryProtocol.swift
//  Asclepione
//
//  Created by Marc Jowett on 14/02/2022.
//

import Foundation
import Combine
import CoreData
import Alamofire

protocol RepositoryProtocol {
    func refreshVaccinationData()
}

extension RepositoryProtocol {
    func insertResultsIntoLocalDatabase() {}
}

class Repository: RepositoryProtocol {
    
    let persistenceContainer: NSPersistentContainer!
    let repositoryUtils: RepositoryUtils!
    
    @Published var newVaccinationsEngland: NewVaccinationsDomainObject = NewVaccinationsDomainObject(country: nil, date: nil, newVaccinations: nil)
    @Published var cumVaccinationsEngland: CumulativeVaccinationsDomainObject = CumulativeVaccinationsDomainObject(country: nil, date: nil, cumulativeVaccinations: nil)
    @Published var uptakePercentagesEngland: UptakePercentageDomainObject = UptakePercentageDomainObject(country: nil, date: nil, thirdDoseUptakePercentage: nil)
    
    init() {
        self.persistenceContainer = PersistenceController.shared.container
        self.repositoryUtils = RepositoryUtils(persistenceContainer: self.persistenceContainer)
    }
    
    func refreshVaccinationData() {
        let api = CoronavirusServiceAPI()
        let cancellable = api.retrieveFromWebAPI().sink { (dataResponse) in
            if dataResponse.error == nil {
                if let vaccinationData = dataResponse.value {
                    self.repositoryUtils.convertDTOToEntities(dto: vaccinationData)
                }
            } else {
                print("Error obtaining data: \(String(describing: dataResponse.error))")
            }
        }
        cancellable.cancel()
        retrieveEntitiesAndConvertToDomainObjects()
        
        let latestDatabaseEntities = repositoryUtils.retrieveEntitiesAndConvertToDomainObjects()
        newVaccinationsEngland = latestDatabaseEntities.newVaccinationsEngland
        cumVaccinationsEngland = latestDatabaseEntities.cumVaccinationsEngland
        uptakePercentagesEngland = latestDatabaseEntities.uptakePercentagesEngland
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
    
}
