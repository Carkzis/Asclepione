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
