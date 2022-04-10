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
    
    // TODO: This needs testing!
    // TODO: Need to add loading icon when refreshing!
    // TODO: Need to add UI tests!
    // TODO: Organise everything!
    // TODO: Add notes to top of methods!
    // TODO: Make it look a bit nicer!
    // TODO: Documentation!
    
    private var repository: Repository!
    var cancellables: Set<AnyCancellable> = []
    
    @Published var country: String = ""
    @Published var date: String = ""
    @Published var newVaccinationsEngland: String = ""
    @Published var cumVaccinationsEngland: String = ""
    @Published var uptakePercentagesEngland: String = ""
    
    /**
     Important note to future Marc, these take the repository and publish the value.  Do not both receive the value here, and then receive again
     when subscribing to the value.  Receive once.
     */
    private var isNewVaccinationsPublisher: AnyPublisher<NewVaccinationsDomainObject, Never> {
        repository.newVaccinationsEnglandPublisher
            .eraseToAnyPublisher()
    }
    private var isCumVaccinationsPublisher: AnyPublisher<CumulativeVaccinationsDomainObject, Never> {
        repository.cumVaccinationsEnglandPublisher
            .eraseToAnyPublisher()
    }
    private var isUptakePercentagesPublisher: AnyPublisher<UptakePercentageDomainObject, Never> {
        repository.uptakePercentagesEnglandPublisher
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
        isNewVaccinationsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                let newVaccines = $0
                self?.setAndPublishCountry(country: newVaccines.country)
                self?.setAndPublishDate(date: newVaccines.date)
                self?.newVaccinationsEngland = formatNumberAsDecimalStyle(numberToFormat: newVaccines.newVaccinations ?? 0)
            }
            .store(in: &cancellables)
        isCumVaccinationsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                let cumVaccines = $0
                self?.setAndPublishCountry(country: cumVaccines.country)
                self?.setAndPublishDate(date: cumVaccines.date)
                self?.cumVaccinationsEngland = formatNumberAsDecimalStyle(numberToFormat: cumVaccines.cumulativeVaccinations ?? 0)
            }
            .store(in: &cancellables)
        isUptakePercentagesPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                let uptakePercentages = $0
                self?.setAndPublishCountry(country: uptakePercentages.country)
                self?.setAndPublishDate(date: uptakePercentages.date)
                self?.uptakePercentagesEngland = "\(String(uptakePercentages.thirdDoseUptakePercentage ?? 0))%"
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
