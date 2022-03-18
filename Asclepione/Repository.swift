//
//  RepositoryProtocol.swift
//  Asclepione
//
//  Created by Marc Jowett on 14/02/2022.
//

import Foundation
import Combine
import CoreData

protocol RepositoryProtocol {
    func refreshVaccinationData()
}

extension RepositoryProtocol {
    func insertResultsIntoLocalDatabase() {}
}

struct Repository: RepositoryProtocol {
    
    let persistenceContainer: NSPersistentContainer!
    
    init() {
        self.persistenceContainer = PersistenceController.shared.container
    }
    
    func refreshVaccinationData() {
        // Not currently implemented.
    }
    
    func convertDTOToEntities(dto: ResponseDTO) {
        let unwrappedDTO = unwrapDTO(dtoToUnwrap: dto)
        convertDTOToNewVaccinations(unwrappedDTO: unwrappedDTO)
        convertDTOToCumulativeVaccinations(unwrappedDTO: unwrappedDTO)
        convertDTOToUptakePercentages(unwrappedDTO: unwrappedDTO)
        insertResultsIntoLocalDatabase()
    }
    
    private func insertResultsIntoLocalDatabase() {
        PersistenceController.shared.save()
    }
    
    private func convertDTOToNewVaccinations(unwrappedDTO: [VaccinationDataDTO]) {
        unwrappedDTO.forEach {
            let uniqueId = createReproducibleUniqueID(date: $0.date, areaName: $0.areaName)
            if (isNewData(uniqueId: uniqueId, .newVaccinations)) {
                let newEntry = NSEntityDescription.insertNewObject(
                    forEntityName: NewVaccinations.entityName, into: persistenceContainer.viewContext) as! NewVaccinations
                newEntry.id = uniqueId
                newEntry.areaName = $0.areaName
                newEntry.date = transformStringIntoDate(dateAsString: $0.date)
                newEntry.newFirstDoses = Int16($0.newPeopleWithFirstDose!)
                newEntry.newSecondDoses = Int16($0.newPeopleWithSecondDose!)
                newEntry.newThirdDoses = Int16($0.newPeopleWithThirdDose!)
                newEntry.newVaccinations = Int16($0.newVaccinations!)
            }
        }
    }
    
    private func convertDTOToCumulativeVaccinations(unwrappedDTO: [VaccinationDataDTO]) {
        unwrappedDTO.forEach {
            let uniqueId = createReproducibleUniqueID(date: $0.date, areaName: $0.areaName)
            if (isNewData(uniqueId: uniqueId, .cumulativeVaccinations)) {
                let newEntry = NSEntityDescription.insertNewObject(
                    forEntityName: CumulativeVaccinations.entityName, into: persistenceContainer.viewContext) as! CumulativeVaccinations
                newEntry.id = uniqueId
                newEntry.areaName = $0.areaName
                newEntry.date = transformStringIntoDate(dateAsString: $0.date)
                newEntry.cumulativeFirstDoses = Int16($0.cumulativeFirstDoses!)
                newEntry.cumulativeSecondDoses = Int16($0.cumulativeSecondDoses!)
                newEntry.cumulativeThirdDoses = Int16($0.cumulativeThirdDoses!)
                newEntry.cumulativeVaccinations = Int16($0.cumulativeVaccinations!)
            }
        }
    }
    
    private func convertDTOToUptakePercentages(unwrappedDTO: [VaccinationDataDTO]) {
        unwrappedDTO.forEach {
            let uniqueId = createReproducibleUniqueID(date: $0.date, areaName: $0.areaName)
            if (isNewData(uniqueId: uniqueId, .uptakePercentages)) {
                let newEntry = NSEntityDescription.insertNewObject(
                    forEntityName: UptakePercentages.entityName, into: persistenceContainer.viewContext) as! UptakePercentages
            
                newEntry.id = uniqueId
                newEntry.areaName = $0.areaName
                newEntry.date = transformStringIntoDate(dateAsString: $0.date)
                newEntry.firstDoseUptakePercentage = $0.firstDoseUptakePercentage!
                newEntry.secondDoseUptakePercentage = $0.secondDoseUptakePercentage!
                newEntry.thirdDoseUptakePercentage = $0.thirdDoseUptakePercentage!
            }
        }
    }
    
    private func isNewData(uniqueId: String, _ dataType: FetchRequests) -> Bool {
        let requestPredicate = NSPredicate(format: "id = %@", uniqueId)
        var results = 0
        
        switch (dataType) {
        case .newVaccinations:
            let fetchRequest = NSFetchRequest<NewVaccinations>(entityName: NewVaccinations.entityName)
            fetchRequest.predicate = requestPredicate
            do{
                results = try persistenceContainer.viewContext.fetch(fetchRequest).count + results
            } catch {
                return false
            }
        case .cumulativeVaccinations:
            let fetchRequest = NSFetchRequest<CumulativeVaccinations>(entityName: CumulativeVaccinations.entityName)
            fetchRequest.predicate = requestPredicate
            do {
                results = try persistenceContainer.viewContext.fetch(fetchRequest).count + results
            } catch {
                return false
            }
        case .uptakePercentages:
            let fetchRequest = NSFetchRequest<UptakePercentages>(entityName: UptakePercentages.entityName)
            fetchRequest.predicate = requestPredicate
            do {
                results = try persistenceContainer.viewContext.fetch(fetchRequest).count + results
            } catch {
                return false
            }
        }
        
        if results == 0 {
            return true
        } else {
            return false
        }
        
    }
    
    enum FetchRequests: CaseIterable {
        case newVaccinations
        case cumulativeVaccinations
        case uptakePercentages
    }
}
