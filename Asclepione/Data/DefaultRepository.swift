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

/**
 Default repository to act as a mediator between the remote REST API, the local CoreData database and the ViewModel.
 */
class DefaultRepository: Repository {
    
    let persistenceContainer: NSPersistentContainer!
    let repositoryUtils: RepositoryUtils!
    
    /*
     Publishers.
     */
    @Published var newVaccinations: NewVaccinationsDomainObject = NewVaccinationsDomainObject(country: nil, date: nil, newVaccinations: nil)
    @Published var cumVaccinations: CumulativeVaccinationsDomainObject = CumulativeVaccinationsDomainObject(country: nil, date: nil, cumulativeVaccinations: nil)
    @Published var uptakePercentages: UptakePercentageDomainObject = UptakePercentageDomainObject(country: nil, date: nil, thirdDoseUptakePercentage: nil)
    @Published var isLoading: Bool = false
    var newVaccinationsPublisher: Published<NewVaccinationsDomainObject>.Publisher { $newVaccinations }
    var cumVaccinationsPublisher: Published<CumulativeVaccinationsDomainObject>.Publisher { $cumVaccinations }
    var uptakePercentagesPublisher: Published<UptakePercentageDomainObject>.Publisher { $uptakePercentages }
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.persistenceContainer = PersistenceController.shared.container
        self.repositoryUtils = RepositoryUtils(persistenceContainer: self.persistenceContainer)
        updatePublishers()
    }
    
    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
    
    /**
     Refreshes the data from the REST API, and updates the local database accordingly.
     Also calls updatePublishers() to publish the current data held in the database to the UI domain.
     */
    func refreshVaccinationData() {
        isLoading = true
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
            self.isLoading = false
        }
        cancellable.store(in: &cancellables)
    }
    
    /**
     Publishes the current data held in the database to the UI domain.
     NOTE: These could potentially end up out of sync, date wise, as they are held in different tables.
     This should be an unlikely occurance, that is rectified the next time the tables are updated.
     This is preferable to raising an exception.
     */
    private func updatePublishers() {
        let latestDatabaseEntities = self.repositoryUtils.retrieveEntitiesAndConvertToDomainObjects()
        self.newVaccinations = latestDatabaseEntities.newVaccinations
        self.cumVaccinations = latestDatabaseEntities.cumVaccinations
        self.uptakePercentages = latestDatabaseEntities.uptakePercentages
    }
    
}
