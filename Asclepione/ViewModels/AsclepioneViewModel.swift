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
    
    private var repository: Repository!
    var cancellables: Set<AnyCancellable> = []
    
    /*
     Publishers.
     */
    @Published var country: String = ""
    @Published var date: String = ""
    @Published var newVaccinations: String = ""
    @Published var cumVaccinations: String = ""
    @Published var uptakePercentages: String = ""
    @Published var isLoading: Bool = false
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
    
    /**
     Refreshes the repository, resulting in a REST API call and an updation of the local database data publishers.
     */
    func refreshVaccinationData() {
        repository.refreshVaccinationData()
    }
    
    /**
     Sets up the Publishers that publish vaccination data to the UI.
     */
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
    
    /**
     Sets up the Publisher that publishes the data loading state to the UI.
     */
    private func setUpLoadingStatePublisher() {
        isLoadingPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.isLoading = $0
            }
            .store(in: &cancellables)
    }
    
    /**
     Sets a country to the country publisher, or "???" if the value is nil.
     */
    private func setAndPublishCountry(country: String?) {
        self.country = country ?? "???"
    }
    
    /**
     Sets a date to the date publisher as a String, or "???" if the value is nil.
     */
    private func setAndPublishDate(date: Date?) {
        if let unwrappedDate = date {
            let dateAsString = transformDateIntoString(dateAsDate: unwrappedDate)
            self.date = dateAsString
        } else {
            self.date = "???"
        }
    }
    
}
