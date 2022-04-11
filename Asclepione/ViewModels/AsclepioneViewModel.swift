//
//  AsclepioneViewModel.swift
//  Asclepione
//
//  Created by Marc Jowett on 18/03/2022.
//

import Foundation
import Combine
import SwiftUI

class AsclepioneViewModel: ObservableObject {
    
    // TODO: Add launch screen!
    // TODO: Need to add UI tests!
    // TODO: Add notes to top of methods!
    // TODO: Documentation!
    // TODO: Icons!
    
    private var repository: Repository!
    var cancellables: Set<AnyCancellable> = []
    
    @Published var country: String = ""
    @Published var date: String = ""
    @Published var newVaccinations: String = ""
    @Published var cumVaccinations: String = ""
    @Published var uptakePercentages: String = ""
    
    /**
     Important note to future Marc, these take the repository and publish the value.  Do not both receive the value here, and then receive again
     when subscribing to the value.  Receive once.
     */
    private var newVaccinationsPublisher: AnyPublisher<NewVaccinationsDomainObject, Never> {
        repository.newVaccinationsPublisher
            .eraseToAnyPublisher()
    }
    private var cumVaccinationsPublisher: AnyPublisher<CumulativeVaccinationsDomainObject, Never> {
        repository.cumVaccinationsPublisher
            .eraseToAnyPublisher()
    }
    private var uptakePercentagesPublisher: AnyPublisher<UptakePercentageDomainObject, Never> {
        repository.uptakePercentagesPublisher
            .eraseToAnyPublisher()
    }
    
    @Published var isLoading: Bool = false
    private var isLoadingPublisher: AnyPublisher<Bool, Never> {
        repository.isLoadingPublisher
            .eraseToAnyPublisher()
    }
    
    init(repository: Repository = DefaultRepository()) {
        self.repository = repository
        
        setUpVaccinationDataPublishers()
        setUpLoadingStatePublisher()
        
        refreshVaccinationData()
    }
    
    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
    
    private func setUpVaccinationDataPublishers() {
        newVaccinationsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                let newVaccines = $0
                self?.setAndPublishCountry(country: newVaccines.country)
                self?.setAndPublishDate(date: newVaccines.date)
                self?.newVaccinations = formatNumberAsDecimalStyle(numberToFormat: newVaccines.newVaccinations ?? 0)
            }
            .store(in: &cancellables)
        cumVaccinationsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                let cumVaccines = $0
                self?.setAndPublishCountry(country: cumVaccines.country)
                self?.setAndPublishDate(date: cumVaccines.date)
                self?.cumVaccinations = formatNumberAsDecimalStyle(numberToFormat: cumVaccines.cumulativeVaccinations ?? 0)
            }
            .store(in: &cancellables)
        uptakePercentagesPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                let uptakePercentages = $0
                self?.setAndPublishCountry(country: uptakePercentages.country)
                self?.setAndPublishDate(date: uptakePercentages.date)
                self?.uptakePercentages = "\(String(uptakePercentages.thirdDoseUptakePercentage ?? 0))%"
            }
            .store(in: &cancellables)
    }
    
    private func setUpLoadingStatePublisher() {
        isLoadingPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.isLoading = $0
            }
            .store(in: &cancellables)
    }
    
    private func setAndPublishCountry(country: String?) {
        self.country = country ?? "???"
    }
    
    private func setAndPublishDate(date: Date?) {
        if let unwrappedDate = date {
            let dateAsString = transformDateIntoString(dateAsDate: unwrappedDate)
            self.date = dateAsString
        } else {
            self.date = "???"
        }
    }
    
    func refreshVaccinationData() {
        repository.refreshVaccinationData()
    }
}
