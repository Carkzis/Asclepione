//
//  RepositoryProtocol.swift
//  Asclepione
//
//  Created by Marc Jowett on 14/02/2022.
//

import Foundation
import Combine

protocol RepositoryProtocol {
    func retrieveVaccinationData() -> AnyPublisher<VaccinationData, Error>
}

struct FakeRepository: RepositoryProtocol {
    
    var networkError = true
    
    func retrieveVaccinationData() -> AnyPublisher<VaccinationData, Error> {
        let response: Result<VaccinationData, Error> = networkError ? .failure(<#T##Error#>) : .success(<#T##VaccinationData#>)
        
        return response.publisher.eraseToAnyPublisher()
    }
    
}
