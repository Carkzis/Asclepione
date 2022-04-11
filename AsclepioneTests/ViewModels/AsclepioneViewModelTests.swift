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
    
    @Published var country: String = ""
    @Published var date: String = ""
    @Published var newVaccinations: String = ""
    @Published var cumVaccinations: String = ""
    @Published var uptakePercentages: String = ""
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
        sut.$newVaccinations
            .eraseToAnyPublisher()
    }
    private var isCumVaccinationsPublisher: AnyPublisher<String, Never> {
        sut.$cumVaccinations
            .eraseToAnyPublisher()
    }
    private var isUptakePercentagesPublisher: AnyPublisher<String, Never> {
        sut.$uptakePercentages
            .eraseToAnyPublisher()
    }
    
    var isLoading: Bool = false
    private var isLoadingPublisher: AnyPublisher<Bool, Never> {
        sut.$isLoading
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
    
    func testWhenDataInDatabaseDataIsPublishedByTheViewModel() throws {
        // Given that there is data in the database.
        repository.emptyDatabase = false
        let countryExpectation = XCTestExpectation(description: "Retrieve country name from database via Publisher.")
        let dateExpectation = XCTestExpectation(description: "Retrieve date data from database via Publisher.")
        let newVaccExpectation = XCTestExpectation(description: "Retrieve new vaccination data from database via Publisher.")
        let cumVaccExpectation = XCTestExpectation(description: "Retrieve cumulative vaccination data from database via Publisher.")
        let uptakePercentageExpectation = XCTestExpectation(description: "Retrieve uptake percentage data from database via Publisher.")

        // When data is refreshed.
        repository.refreshVaccinationData()

        // Then the data from the CoreData database should be published using Combine via the repository.
        cancellables = getCancellables(countryExpectation: countryExpectation, dateExpectation: dateExpectation, newVaccExpectation: newVaccExpectation, cumVaccExpectation: cumVaccExpectation, uptakePercentageExpectation: uptakePercentageExpectation)

        wait(for: [countryExpectation], timeout: 10)
        wait(for: [dateExpectation], timeout: 10)
        wait(for: [newVaccExpectation], timeout: 10)
        wait(for: [cumVaccExpectation], timeout: 10)
        wait(for: [uptakePercentageExpectation], timeout: 10)

        XCTAssertFalse(self.country == "???")
        XCTAssertFalse(self.date == "???")
        XCTAssertFalse(self.newVaccinations == "0")
        XCTAssertFalse(self.cumVaccinations == "0")
        XCTAssertFalse(self.uptakePercentages == "0%")
    }
    
    func testWhenDataFromDatabaseInViewModelCorrectlyFormatted() throws {
        // Given that there is data in the database.
        repository.emptyDatabase = false
        
        /*
         These are the default items returned by ReponseDTO.retrieveResponseData(), use by the MockRepository.
         */
        XCTAssertFalse(sut.country == "England")
        XCTAssertFalse(sut.date == "01/01/1900")
        XCTAssertFalse(sut.newVaccinations == "300")
        XCTAssertFalse(sut.cumVaccinations == "3000")
        XCTAssertFalse(sut.uptakePercentages == "10%")
    }
    
    func testWhenNoDataInDatabaseDefaultStringsArePublishedByTheViewModel() throws {
        // Given that there is no data in the database.
        repository.emptyDatabase = true
        let countryExpectation = XCTestExpectation(description: "Retrieve country name from database via Publisher.")
        let dateExpectation = XCTestExpectation(description: "Retrieve date data from database via Publisher.")
        let newVaccExpectation = XCTestExpectation(description: "Retrieve new vaccination data from database via Publisher.")
        let cumVaccExpectation = XCTestExpectation(description: "Retrieve cumulative vaccination data from database via Publisher.")
        let uptakePercentageExpectation = XCTestExpectation(description: "Retrieve uptake percentage data from database via Publisher.")
        
        // When data is refreshed.
        repository.refreshVaccinationData()
        
        // Then the data from the CoreData database should be published using Combine via the repository.
        cancellables = getCancellables(countryExpectation: countryExpectation, dateExpectation: dateExpectation, newVaccExpectation: newVaccExpectation, cumVaccExpectation: cumVaccExpectation, uptakePercentageExpectation: uptakePercentageExpectation)
        
        wait(for: [countryExpectation], timeout: 10)
        wait(for: [dateExpectation], timeout: 10)
        wait(for: [newVaccExpectation], timeout: 10)
        wait(for: [cumVaccExpectation], timeout: 10)
        wait(for: [uptakePercentageExpectation], timeout: 10)

        XCTAssertTrue(self.country == "???")
        XCTAssertTrue(self.date == "???")
        XCTAssertTrue(self.newVaccinations == "0")
        XCTAssertTrue(self.cumVaccinations == "0")
        XCTAssertTrue(self.uptakePercentages == "0%")
    }
    
    func testLoadingStateOnInitalisationPublishedAsTrueWhileLoadingThenFalseOnSuccessfulResponse() throws {
        // Given there is a ViewModel.
        
        // When a request to refresh the data via the network is called on initalisation.
        let isLoadingExpectation = XCTestExpectation(description: "Informed loading is occuring via Publisher.")
        let isNotLoadingExpectation = XCTestExpectation(description: "Informed loading has stopped via Publisher.")
        var resultList: [Bool] = []
        cancellables = [isLoadingPublisher
                        .receive(on: RunLoop.main)
                        .sink { [weak self] in
                        self?.isLoading = $0
                        if $0 {
                            isLoadingExpectation.fulfill()
                        } else {
                            isNotLoadingExpectation.fulfill()
                        }
            resultList.append($0)
        }]
        
        // Then we should get a stream of loading being false (on initialisation), false, then true, then false.
        wait(for: [isLoadingExpectation], timeout: 10)
        wait(for: [isNotLoadingExpectation], timeout: 10)
        print(resultList)
        XCTAssert(!resultList[0])
        XCTAssert(!resultList[1])
        XCTAssert(resultList[2])
        XCTAssert(!resultList[3])
    }
    
    func testLoadingStateOnRefreshPublishedAsTrueWhileLoadingThenFalseOnSuccessfulResponse() throws {
        // Given there is a ViewModel.
        
        // When a request to refresh the data subsequent to initialisation via the network is called.
        let isLoadingExpectation = XCTestExpectation(description: "Informed loading is occuring via Publisher.")
        let isNotLoadingExpectation = XCTestExpectation(description: "Informed loading has stopped via Publisher.")
        var resultList: [Bool] = []
        cancellables = [isLoadingPublisher
                        .receive(on: RunLoop.main)
                        .sink { [weak self] in
                        self?.isLoading = $0
                        if $0 {
                            isLoadingExpectation.fulfill()
                        } else {
                            isNotLoadingExpectation.fulfill()
                        }
            resultList.append($0)
        }]
        
        // Then we should get a stream of loading being false (on initialisation), false, then true, then false.
        // Then we should get true and then false.
        wait(for: [isLoadingExpectation], timeout: 10)
        wait(for: [isNotLoadingExpectation], timeout: 10)
        print(resultList)
        XCTAssert(!resultList[0])
        XCTAssert(!resultList[1])
        XCTAssert(resultList[2])
        XCTAssert(!resultList[3])
        XCTAssert(resultList[2])
        XCTAssert(!resultList[3])
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
            self?.newVaccinations = $0
            newVaccExpectation.fulfill()
        },
                isCumVaccinationsPublisher
                    .receive(on: RunLoop.main)
                    .sink { [weak self] in
            self?.cumVaccinations = $0
            cumVaccExpectation.fulfill()
        },
                isUptakePercentagesPublisher
                    .receive(on: RunLoop.main)
                    .sink { [weak self] in
            self?.uptakePercentages = $0
            uptakePercentageExpectation.fulfill()
        }]
        
    }
    
}
