//
//  AsclepioneViewModel.swift
//  Asclepione
//
//  Created by Marc Jowett on 18/03/2022.
//

import Foundation
import Combine

class AsclepioneViewModel: ObservableObject {
    
    private var repository: RepositoryProtocol!
    
    @Published var newVaccinationsEngland: NewVaccinationsDomainObject = NewVaccinationsDomainObject(country: nil, date: nil, newVaccinations: nil)
    @Published var cumVaccinationsEngland: CumulativeVaccinationsDomainObject = CumulativeVaccinationsDomainObject(country: nil, date: nil, cumulativeVaccinations: nil)
    @Published var uptakePercentagesEngland: UptakePercentageDomainObject = UptakePercentageDomainObject(country: nil, date: nil, thirdDoseUptakePercentage: nil)
    
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
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
        
        isNewVaccinationsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.newVaccinationsEngland = $0
            }
        isCumVaccinationsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.cumVaccinationsEngland = $0
            }
        isUptakePercentagesPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.uptakePercentagesEngland = $0
            }
    }
}
