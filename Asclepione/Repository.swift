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
    func refreshVaccinationData() {
        // Not currently implemented.
    }
}
