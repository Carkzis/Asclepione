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
    var newVaccinationsEnglandPublisher: Published<NewVaccinationsDomainObject>.Publisher { get }
    var cumVaccinationsEnglandPublisher: Published<CumulativeVaccinationsDomainObject>.Publisher { get }
    var uptakePercentagesEnglandPublisher: Published<UptakePercentageDomainObject>.Publisher { get }
}

extension RepositoryProtocol {
    func insertResultsIntoLocalDatabase() {}
}

class Repository: RepositoryProtocol {
    
    let persistenceContainer: NSPersistentContainer!
    let repositoryUtils: RepositoryUtils!
    
    @Published var newVaccinationsEngland: NewVaccinationsDomainObject = NewVaccinationsDomainObject(country: nil, date: nil, newVaccinations: nil)
    @Published var cumVaccinationsEngland: CumulativeVaccinationsDomainObject = CumulativeVaccinationsDomainObject(country: nil, date: nil, cumulativeVaccinations: nil)
    @Published var uptakePercentagesEngland: UptakePercentageDomainObject = UptakePercentageDomainObject(country: nil, date: nil, thirdDoseUptakePercentage: nil)
    
    var newVaccinationsEnglandPublisher: Published<NewVaccinationsDomainObject>.Publisher { $newVaccinationsEngland }
    var cumVaccinationsEnglandPublisher: Published<CumulativeVaccinationsDomainObject>.Publisher { $cumVaccinationsEngland }
    var uptakePercentagesEnglandPublisher: Published<UptakePercentageDomainObject>.Publisher { $uptakePercentagesEngland }
    
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
        
        let latestDatabaseEntities = repositoryUtils.retrieveEntitiesAndConvertToDomainObjects()
        newVaccinationsEngland = latestDatabaseEntities.newVaccinationsEngland
        cumVaccinationsEngland = latestDatabaseEntities.cumVaccinationsEngland
        uptakePercentagesEngland = latestDatabaseEntities.uptakePercentagesEngland
    }

}
