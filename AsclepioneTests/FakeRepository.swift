//
//  FakeRepository.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 08/03/2022.
//

import Foundation
@testable import Asclepione

/*
 This is a fake repository class that uses the actual CoreData database.
 */
class FakeRepository: RepositoryProtocol {
    
    let repositoryUtils: RepositoryUtils!
    var multipleUniqueDataItemsReceived = false
    
    @Published var newVaccinations: [NewVaccinationsDomainObject] = []
    @Published var cumVaccinations: [CumulativeVaccinationsDomainObject] = []
    @Published var uptakePercentages: [UptakePercentageDomainObject] = []
    
    func refreshVaccinationData() {
        // This will grab fake data and convert it into entities.
        let mockData: ResponseDTO!
        if (multipleUniqueDataItemsReceived) {
            mockData = ResponseDTO.retrieveUniqueResponseData(amountOfItems: 4)
        } else {
            mockData = ResponseDTO.retrieveResponseData(amountOfItems: 4)
        }
        repositoryUtils.convertDTOToEntities(dto: mockData)
    }
    
    init() {
        _ = PersistenceController(inMemory: true)
        let persistenceContainer = PersistenceController.shared.container
        self.repositoryUtils = RepositoryUtils(persistenceContainer: persistenceContainer)
    }
    
}
