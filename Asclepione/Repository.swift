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

class Repository: RepositoryProtocol {
    
    let persistenceContainer: NSPersistentContainer!
    let repositoryUtils: RepositoryUtils!
    
    init() {
        self.persistenceContainer = PersistenceController.shared.container
        self.repositoryUtils = RepositoryUtils(persistenceContainer: self.persistenceContainer)
    }
    
    func refreshVaccinationData() {
        // Not currently implemented.
    }
    
}
