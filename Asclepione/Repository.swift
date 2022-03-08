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
    
    init(_ persistenceController: PersistenceController = PersistenceController.shared) {
        persistenceContainer = persistenceController.container
    }
    
    func refreshVaccinationData() {
        // Not currently implemented.
    }
    
    func convertDTOtoEntities(dto: ResponseDTO) {
        let unwrappedDTO = unwrapDTO(dtoToUnwrap: dto)
        convertDTOtoNewVaccinations(unwrappedDTO: unwrappedDTO)
        insertResultsIntoLocalDatabase()
    }
    
    func insertResultsIntoLocalDatabase() {
        PersistenceController.shared.save()
    }
    
    private func convertDTOtoNewVaccinations(unwrappedDTO: [VaccinationDataDTO]) {
        // TODO: Check this works.
        unwrappedDTO.forEach{
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
    
}
