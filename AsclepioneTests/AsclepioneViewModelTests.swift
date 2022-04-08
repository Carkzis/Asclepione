//
//  AsclepioneViewModelTests.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 08/04/2022.
//

import XCTest
import Combine

@testable import Asclepione

class AsclepioneViewModelTests: XCTestCase {
    
    var sut: AsclepioneViewModel!
    var repository: MockRepository!
    
    @Published var country: String = "dog"
    @Published var date: String = ""
    @Published var newVaccinationsEngland: String = ""
    @Published var cumVaccinationsEngland: String = ""
    @Published var uptakePercentagesEngland: String = ""
    private var cancellables: Set<AnyCancellable> = []
    
    private var isCountryPublisher: AnyPublisher<String, Never> {
        sut.$country
            .eraseToAnyPublisher()
    }
    private var isDatePublisher: AnyPublisher<String, Never> {
        sut.$date
            .eraseToAnyPublisher()
    }
    private var isNewVaccinationsPublisher: AnyPublisher<String, Never> {
        sut.$newVaccinationsEngland
            .eraseToAnyPublisher()
    }
    private var isCumVaccinationsPublisher: AnyPublisher<String, Never> {
        sut.$cumVaccinationsEngland
            .eraseToAnyPublisher()
    }
    private var isUptakePercentagesPublisher: AnyPublisher<String, Never> {
        sut.$uptakePercentagesEngland
            .eraseToAnyPublisher()
    }
    
    override func setUpWithError() throws {
        repository = MockRepository()
        sut = AsclepioneViewModel(repository: repository)
    }

    override func tearDownWithError() throws {
        for cancellable in cancellables {
            cancellable.cancel()
        }
        repository = nil
    }
    
    func testWhenDataInDatabaseDataIsPublishedByCombine() throws {
        // Given that there is data in the database.
        repository.emptyDatabase = false
        let countryExpectation = XCTestExpectation(description: "Retrieve country name from database via Publisher.")
        let dateExpectation = XCTestExpectation(description: "Retrieve date data from database via Publisher.")
        let newVaccExpectation = XCTestExpectation(description: "Retrieve new vaccination data from database via Publisher.")
        let cumVaccExpectation = XCTestExpectation(description: "Retrieve cumulative vaccination data from database via Publisher.")
        let uptakePercentageExpectation = XCTestExpectation(description: "Retrieve uptake percentage data from database via Publisher.")
        
        print("\(self.country) still whyyyyy" )
        
        // When data is refreshed.
        repository.refreshVaccinationData()
        
        // Then the data from the CoreData database should be published using Combine via the repository.
        cancellables = getCancellables(countryExpectation: countryExpectation, dateExpectation: dateExpectation, newVaccExpectation: newVaccExpectation, cumVaccExpectation: cumVaccExpectation, uptakePercentageExpectation: uptakePercentageExpectation)
        
        wait(for: [countryExpectation], timeout: 10)
        wait(for: [dateExpectation], timeout: 10)
        wait(for: [newVaccExpectation], timeout: 10)
        wait(for: [cumVaccExpectation], timeout: 10)
        wait(for: [uptakePercentageExpectation], timeout: 10)

        print("\(self.country) still whyyyyy" )
        print("\(self.sut.country) but this okay" )
        print(sut.cancellables)
        XCTAssertFalse(self.country.isEmpty)
        XCTAssertFalse(self.date.isEmpty)
        XCTAssertFalse(self.newVaccinationsEngland.isEmpty)
        XCTAssertFalse(self.cumVaccinationsEngland.isEmpty)
        XCTAssertFalse(self.uptakePercentagesEngland.isEmpty)
        
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
    
    func getCancellables(countryExpectation: XCTestExpectation, dateExpectation: XCTestExpectation, newVaccExpectation: XCTestExpectation, cumVaccExpectation: XCTestExpectation, uptakePercentageExpectation: XCTestExpectation) -> Set<AnyCancellable> {
        return [isCountryPublisher
                    .receive(on: RunLoop.main)
                    .sink { [weak self] in
            self?.country = $0
            countryExpectation.fulfill()
        },
                isDatePublisher
                    .receive(on: RunLoop.main)
                    .sink { [weak self] in
            self?.date = $0
            dateExpectation.fulfill()
        },
                isNewVaccinationsPublisher
                    .receive(on: RunLoop.main)
                    .sink { [weak self] in
            self?.newVaccinationsEngland = $0
            newVaccExpectation.fulfill()
        },
                isCumVaccinationsPublisher
                    .receive(on: RunLoop.main)
                    .sink { [weak self] in
            self?.cumVaccinationsEngland = $0
            cumVaccExpectation.fulfill()
        },
                isUptakePercentagesPublisher
                    .receive(on: RunLoop.main)
                    .sink { [weak self] in
            self?.uptakePercentagesEngland = $0
            uptakePercentageExpectation.fulfill()
        }]
        
    }
    
}
