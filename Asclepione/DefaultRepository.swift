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

protocol Repository {
    func refreshVaccinationData()
    var newVaccinationsEnglandPublisher: Published<NewVaccinationsDomainObject>.Publisher { get }
    var cumVaccinationsEnglandPublisher: Published<CumulativeVaccinationsDomainObject>.Publisher { get }
    var uptakePercentagesEnglandPublisher: Published<UptakePercentageDomainObject>.Publisher { get }
}

extension Repository {
    func insertResultsIntoLocalDatabase() {}
}

class DefaultRepository: Repository {
    
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
        updatePublishers()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    func refreshVaccinationData() {
        let api = CoronavirusServiceAPI()
        let cancellable = api.retrieveFromWebAPI().sink { (dataResponse) in
            if dataResponse.error == nil {
                if let vaccinationData = dataResponse.value {
                    self.repositoryUtils.convertDTOToEntities(dto: vaccinationData)
                    self.updatePublishers()
                }
            } else {
                print("Error obtaining data: \(String(describing: dataResponse.error))")
            }
        }
        cancellable.store(in: &cancellables)
    }
    
    private func updatePublishers() {
        let latestDatabaseEntities = self.repositoryUtils.retrieveEntitiesAndConvertToDomainObjects()
        self.newVaccinationsEngland = latestDatabaseEntities.newVaccinationsEngland
        self.cumVaccinationsEngland = latestDatabaseEntities.cumVaccinationsEngland
        self.uptakePercentagesEngland = latestDatabaseEntities.uptakePercentagesEngland
    }

    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
}