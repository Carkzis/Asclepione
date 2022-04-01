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
    
    init(repository: RepositoryProtocol = Repository()) {
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
        if (self.country != "" && self.country != country) {
            fatalError("The countries do not match between publishers.")
        } else {
            self.country = country ?? ""
        }
    }
    
    private func setAndPublishDate(date: Date?) {
        if let unwrappedDate = date {
            let dateAsString = transformDateIntoString(dateAsDate: unwrappedDate)
            if (self.date != "" && self.date != dateAsString) {
                fatalError("The dates are different between vaccination data types.")
            } else {
                self.date = dateAsString
            }
        }
    }
    
    func refreshVaccinationData() {
        repository.refreshVaccinationData()
    }
}
