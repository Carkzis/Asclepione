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
    }
    
    init() {
        print(PersistenceController.shared.container)
        _ = PersistenceController(inMemory: true)
        repository = Repository()
        print(PersistenceController.shared.container)
    }
    
}
