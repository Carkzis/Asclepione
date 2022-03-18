//
//  FakeRepository.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 08/03/2022.
//

import Foundation
@testable import Asclepione

class FakeRepository: RepositoryProtocol {
    
    let repository: Repository!
    
    func refreshVaccinationData() {
        // This will grab fake data and convert it into entities.
        let mockData = ResponseDTO.retrieveResponseData(amountOfItems: 4)
        repository.convertDTOToEntities(dto: mockData)
        
        // This saves the entities into the database.
        repository.insertResultsIntoLocalDatabase()
    }
    
    init() {
        repository = Repository(PersistenceController(inMemory: true))
    }
    
}
