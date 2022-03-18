//
//  FakeRepository.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 08/03/2022.
//

import Foundation
@testable import Asclepione

class FakeRepository: RepositoryProtocol {
    
    let repositoryUtils: RepositoryUtils!
    
    func refreshVaccinationData() {
        // This will grab fake data and convert it into entities.
        let mockData = ResponseDTO.retrieveResponseData(amountOfItems: 4)
        repositoryUtils.convertDTOToEntities(dto: mockData)
    }
    
    init() {
        _ = PersistenceController(inMemory: true)
        let persistenceContainer = PersistenceController.shared.container
        self.repositoryUtils = RepositoryUtils(persistenceContainer: persistenceContainer)
    }
    
}
