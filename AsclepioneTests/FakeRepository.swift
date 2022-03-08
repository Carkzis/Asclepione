//
//  FakeRepository.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 08/03/2022.
//

import Foundation
@testable import Asclepione

class FakeRepository: RepositoryProtocol {
    
    let repository: RepositoryProtocol!
    
    func refreshVaccinationData() {
        // TODO: Insert fake data into CoreData, but in memory.
        
        // Remember, this just "saves" the changes to the database!
        repository.insertResultsIntoLocalDatabase()
    }
    
    init() {
        repository = Repository(PersistenceController(inMemory: true))
    }
    
}
