//
//  RepositoryUtils.swift
//  Asclepione
//
//  Created by Marc Jowett on 18/03/2022.
//

import Foundation
import CoreData

class RepositoryUtils {
    let persistenceContainer: NSPersistentContainer!
    
    init(persistenceContainer: NSPersistentContainer) {
        self.persistenceContainer = persistenceContainer
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
            if (isNewData(uniqueId: uniqueId, entityName: NewVaccinations.entityName)) {
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
            if (isNewData(uniqueId: uniqueId, entityName: CumulativeVaccinations.entityName)) {
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
            if (isNewData(uniqueId: uniqueId, entityName: UptakePercentages.entityName)) {
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
    
    private func isNewData(uniqueId: String, entityName: String) -> Bool {
        let requestPredicate = NSPredicate(format: "id = %@", uniqueId)
        var results = 0
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = requestPredicate
        do{
            results = try persistenceContainer.viewContext.fetch(fetchRequest).count + results
        } catch {
            return false
        }
        
        if results == 0 {
            return true
        } else {
            return false
        }
    }
        
}