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
                newEntry.newFirstDoses = Int32($0.newPeopleWithFirstDose!)
                newEntry.newSecondDoses = Int32($0.newPeopleWithSecondDose!)
                newEntry.newThirdDoses = Int32($0.newPeopleWithThirdDose!)
                newEntry.newVaccinations = Int32($0.newVaccinations!)
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
                newEntry.cumulativeFirstDoses = Int32($0.cumulativeFirstDoses!)
                newEntry.cumulativeSecondDoses = Int32($0.cumulativeSecondDoses!)
                newEntry.cumulativeThirdDoses = Int32($0.cumulativeThirdDoses!)
                newEntry.cumulativeVaccinations = Int32($0.cumulativeVaccinations!)
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
    
    struct DomainObjects {
        let newVaccinationsEngland: NewVaccinationsDomainObject
        let cumVaccinationsEngland: CumulativeVaccinationsDomainObject
        let uptakePercentagesEngland: UptakePercentageDomainObject
    }
    
    func retrieveEntitiesAndConvertToDomainObjects() -> DomainObjects {
        let newVaccinationsEngland = retrieveNewVaccinationEntitiesAndConvertToDomainObjects()
        let cumVaccinationsEngland = retrieveCumulativeVaccinationEntitiesAndConvertToDomainObjects()
        let uptakePercentagesEngland = retrieveUptakePercentageEntitiesAndConvertToDomainObjects()
        return DomainObjects(newVaccinationsEngland: newVaccinationsEngland, cumVaccinationsEngland: cumVaccinationsEngland, uptakePercentagesEngland: uptakePercentagesEngland)
    }
    
    private func retrieveNewVaccinationEntitiesAndConvertToDomainObjects() -> NewVaccinationsDomainObject {
        let newVaccinationsFetchRequest = NSFetchRequest<NewVaccinations>(entityName: NewVaccinations.entityName)
        let sortDescriptor = NSSortDescriptor(key: #keyPath(NewVaccinations.date), ascending: false)
        newVaccinationsFetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let latestNewVaccinationsData = try self.persistenceContainer
                .viewContext
                .fetch(newVaccinationsFetchRequest)
                .map { entity in
                    NewVaccinationsDomainObject(country: entity.areaName!, date: entity.date!, newVaccinations: Int(entity.newThirdDoses))
                }.first
            return latestNewVaccinationsData ?? NewVaccinationsDomainObject(country: nil, date: nil, newVaccinations: nil)
        } catch {
            print("Something went wrong fetching new vaccination data: \(error)")
            return NewVaccinationsDomainObject(country: nil, date: nil, newVaccinations: nil)
        }
    }
    
    private func retrieveCumulativeVaccinationEntitiesAndConvertToDomainObjects() -> CumulativeVaccinationsDomainObject {
        let cumVaccinationsFetchRequest = NSFetchRequest<CumulativeVaccinations>(entityName: CumulativeVaccinations.entityName)
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CumulativeVaccinations.date), ascending: false)
        cumVaccinationsFetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let latestCumVaccinationsData = try self.persistenceContainer
                .viewContext
                .fetch(cumVaccinationsFetchRequest)
                .map { entity in
                    CumulativeVaccinationsDomainObject(country: entity.areaName!, date: entity.date!, cumulativeVaccinations: Int(entity.cumulativeThirdDoses))
                }.first
            return latestCumVaccinationsData ?? CumulativeVaccinationsDomainObject(country: nil, date: nil, cumulativeVaccinations: nil)
        } catch {
            print("Something went wrong fetching cumulative vaccination data: \(error)")
            return CumulativeVaccinationsDomainObject(country: nil, date: nil, cumulativeVaccinations: nil)
        }
    }
    
    private func retrieveUptakePercentageEntitiesAndConvertToDomainObjects() -> UptakePercentageDomainObject {
        let uptakePercentageFetchRequest = NSFetchRequest<UptakePercentages>(entityName: UptakePercentages.entityName)
        let sortDescriptor = NSSortDescriptor(key: #keyPath(UptakePercentages.date), ascending: false)
        uptakePercentageFetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let latestUptakePercentagesData = try self.persistenceContainer
                .viewContext
                .fetch(uptakePercentageFetchRequest)
                .map { entity in
                    UptakePercentageDomainObject(country: entity.areaName!, date: entity.date!, thirdDoseUptakePercentage: Int(entity.thirdDoseUptakePercentage))
                }.first
            return latestUptakePercentagesData ?? UptakePercentageDomainObject(country: nil, date: nil, thirdDoseUptakePercentage: nil)
        } catch {
            print("Something went wrong fetching uptake percentages data: \(error)")
            return UptakePercentageDomainObject(country: nil, date: nil, thirdDoseUptakePercentage: nil)
        }
    }
        
}
