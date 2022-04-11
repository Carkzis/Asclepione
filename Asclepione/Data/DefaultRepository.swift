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

class DefaultRepository: Repository {
    
    let persistenceContainer: NSPersistentContainer!
    let repositoryUtils: RepositoryUtils!
    
    @Published var newVaccinations: NewVaccinationsDomainObject = NewVaccinationsDomainObject(country: nil, date: nil, newVaccinations: nil)
    @Published var cumVaccinations: CumulativeVaccinationsDomainObject = CumulativeVaccinationsDomainObject(country: nil, date: nil, cumulativeVaccinations: nil)
    @Published var uptakePercentages: UptakePercentageDomainObject = UptakePercentageDomainObject(country: nil, date: nil, thirdDoseUptakePercentage: nil)

    var newVaccinationsPublisher: Published<NewVaccinationsDomainObject>.Publisher { $newVaccinations }
    var cumVaccinationsPublisher: Published<CumulativeVaccinationsDomainObject>.Publisher { $cumVaccinations }
    var uptakePercentagesPublisher: Published<UptakePercentageDomainObject>.Publisher { $uptakePercentages }
    
    @Published var isLoading: Bool = false
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    
    init() {
        self.persistenceContainer = PersistenceController.shared.container
        self.repositoryUtils = RepositoryUtils(persistenceContainer: self.persistenceContainer)
        updatePublishers()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
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
    
    private func updatePublishers() {
        let latestDatabaseEntities = self.repositoryUtils.retrieveEntitiesAndConvertToDomainObjects()
        self.newVaccinations = latestDatabaseEntities.newVaccinations
        self.cumVaccinations = latestDatabaseEntities.cumVaccinations
        self.uptakePercentages = latestDatabaseEntities.uptakePercentages
    }

    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
}
