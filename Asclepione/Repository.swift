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

struct Repository: RepositoryProtocol {
    
    let persistenceContainer: NSPersistentContainer!
    
    init() {
        let persistenceController = PersistenceController.shared
        persistenceContainer = persistenceController.container
    }
    
    func refreshVaccinationData() {
        // Not currently implemented.
    }
    
    private func convertDTOtoEntities(dto: ResponseDTO) {
        let unwrappedDTO = unwrapDTO(dtoToUnwrap: dto)
        convertDTOtoNewVaccinations(unwrappedDTO: unwrappedDTO)
        insertResultsIntoLocalDatabase()
    }
    
    private func insertResultsIntoLocalDatabase() {
        PersistenceController.shared.save()
    }
    
    private func convertDTOtoNewVaccinations(unwrappedDTO: [VaccinationDataDTO]) {
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
    
    // TODO: Move these into a common utilities class, or use an abstract Repository class.

    private func unwrapDTO(dtoToUnwrap: ResponseDTO) -> [VaccinationDataDTO] {
        if let unwrappedDTO = dtoToUnwrap.data {
            return unwrappedDTO
        } else {
            return []
        }
    }
    
    private func createReproducibleUniqueID(date: String, areaName: String) -> String {
        return "\(date)\(areaName)"
    }
    
    private func transformStringIntoDate(dateAsString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_UK")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // TODO: May be better to throw an error here.
        if let date = dateFormatter.date(from: dateAsString) {
            return date
        } else {
            let defaultDate = "1900-01-01"
            return dateFormatter.date(from: defaultDate)!
        }
    }
    
}
