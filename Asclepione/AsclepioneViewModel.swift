//
//  AsclepioneViewModel.swift
//  Asclepione
//
//  Created by Marc Jowett on 18/03/2022.
//

import Foundation
import Combine

class AsclepioneViewModel: ObservableObject {
    
    // TODO: This needs testing! Add publishers to the MockRepository!
    // TODO: Need to add loading icon when refreshing!
    // TODO: Need to add UI tests!
    // TODO: Organise everything!
    // TODO: Add notes to top of methods!
    // TODO: Make it look a bit nicer!
    // TODO: Documentation!
    
    private var repository: Repository!
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var country: String = ""
    @Published var date: String = ""
    @Published var newVaccinationsEngland: String = ""
    @Published var cumVaccinationsEngland: String = ""
    @Published var uptakePercentagesEngland: String = ""
    
    private var isNewVaccinationsPublisher: AnyPublisher<NewVaccinationsDomainObject, Never> {
        repository.newVaccinationsEnglandPublisher
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    private var isCumVaccinationsPublisher: AnyPublisher<CumulativeVaccinationsDomainObject, Never> {
        repository.cumVaccinationsEnglandPublisher
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    private var isUptakePercentagesPublisher: AnyPublisher<UptakePercentageDomainObject, Never> {
        repository.uptakePercentagesEnglandPublisher
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    init(repository: Repository = DefaultRepository()) {
        self.repository = repository
        repository.refreshVaccinationData()
        
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
                print(uptakePercentages)
                self?.setAndPublishCountry(country: uptakePercentages.country)
                self?.setAndPublishDate(date: uptakePercentages.date)
                self?.uptakePercentagesEngland = "\(String(uptakePercentages.thirdDoseUptakePercentage ?? 0))%"
            }
            .store(in: &cancellables)
    }
    
    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
    
    private func setAndPublishCountry(country: String?) {
        self.country = country ?? ""
    }
    
    private func setAndPublishDate(date: Date?) {
        if let unwrappedDate = date {
            let dateAsString = transformDateIntoString(dateAsDate: unwrappedDate)
            self.date = dateAsString
        }
    }
    
    func refreshVaccinationData() {
        repository.refreshVaccinationData()
    }
}
