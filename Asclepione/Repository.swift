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
        // TODO: Check this works.
        unwrappedDTO.forEach {
            let newEntry = NSEntityDescription.insertNewObject(
                forEntityName: NewVaccinations.entityName, into: persistenceContainer.viewContext) as! NewVaccinations
        
            newEntry.id = createReproducibleUniqueID(date: $0.date, areaName: $0.areaName)
            newEntry.areaName = $0.areaName
            newEntry.date = transformStringIntoDate(dateAsString: $0.date)
            newEntry.newFirstDoses = Int16($0.newPeopleWithFirstDose!)
            newEntry.newSecondDoses = Int16($0.newPeopleWithSecondDose!)
            newEntry.newThirdDoses = Int16($0.newPeopleWithThirdDose!)
            newEntry.newVaccinations = Int16($0.newVaccinations!)
        }
    }
    
    private func convertDTOToCumulativeVaccinations(unwrappedDTO: [VaccinationDataDTO]) {
        // TODO: Check this works.
        unwrappedDTO.forEach {
            let newEntry = NSEntityDescription.insertNewObject(
                forEntityName: CumulativeVaccinations.entityName, into: persistenceContainer.viewContext) as! CumulativeVaccinations

            newEntry.id = createReproducibleUniqueID(date: $0.date, areaName: $0.areaName)
            newEntry.areaName = $0.areaName
            newEntry.date = transformStringIntoDate(dateAsString: $0.date)
            newEntry.cumulativeFirstDoses = Int16($0.cumulativeFirstDoses!)
            newEntry.cumulativeSecondDoses = Int16($0.cumulativeSecondDoses!)
            newEntry.cumulativeThirdDoses = Int16($0.cumulativeThirdDoses!)
            newEntry.cumulativeVaccinations = Int16($0.cumulativeVaccinations!)
        }
    }
    
    private func convertDTOToUptakePercentages(unwrappedDTO: [VaccinationDataDTO]) {
        // TODO: Check this works.
        unwrappedDTO.forEach {
            let newEntry = NSEntityDescription.insertNewObject(
                forEntityName: UptakePercentages.entityName, into: persistenceContainer.viewContext) as! UptakePercentages
            
            newEntry.id = createReproducibleUniqueID(date: $0.date, areaName: $0.areaName)
            newEntry.areaName = $0.areaName
            newEntry.date = transformStringIntoDate(dateAsString: $0.date)
            newEntry.firstDoseUptakePercentage = $0.firstDoseUptakePercentage!
            newEntry.secondDoseUptakePercentage = $0.secondDoseUptakePercentage!
            newEntry.thirdDoseUptakePercentage = $0.thirdDoseUptakePercentage!
        }
    }
    
}
