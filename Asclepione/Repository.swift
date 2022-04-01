//
//  RepositoryProtocol.swift
//  Asclepione
//
//  Created by Marc Jowett on 14/02/2022.
//

import Foundation
import Combine
import CoreData
import Alamofire

protocol RepositoryProtocol {
    func refreshVaccinationData()
}

extension RepositoryProtocol {
    func insertResultsIntoLocalDatabase() {}
}

class Repository: RepositoryProtocol {
    
    let persistenceContainer: NSPersistentContainer!
    let repositoryUtils: RepositoryUtils!
    
    // TODO: Obtain data from CoreData database using Combine, manually on results from both init and refresh.
    
    init() {
        self.persistenceContainer = PersistenceController.shared.container
        self.repositoryUtils = RepositoryUtils(persistenceContainer: self.persistenceContainer)
    }
    
    func refreshVaccinationData() {
        let api = CoronavirusServiceAPI()
        let cancellable = api.retrieveFromWebAPI().sink { (dataResponse) in
            if dataResponse.error == nil {
                if let vaccinationData = dataResponse.value {
                    self.repositoryUtils.convertDTOToEntities(dto: vaccinationData)
                }
            } else {
                print("Error obtaining data: \(String(describing: dataResponse.error))")
            }
        }
        cancellable.cancel()
    }
    
}
