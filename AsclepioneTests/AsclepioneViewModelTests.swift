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
    var repository: Repository!
    
    @Published var country: String = ""
    @Published var date: String = ""
    @Published var newVaccinationsEngland: String = ""
    @Published var cumVaccinationsEngland: String = ""
    @Published var uptakePercentagesEngland: String = ""
    private var cancellables: Set<AnyCancellable> = []
    
    private var isCountryPublisher: AnyPublisher<String, Never> {
        sut.$country
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    private var isDatePublisher: AnyPublisher<String, Never> {
        sut.$date
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    private var isNewVaccinationsEngland: AnyPublisher<String, Never> {
        sut.$newVaccinationsEngland
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    private var isCumVaccinationsEngland: AnyPublisher<String, Never> {
        sut.$cumVaccinationsEngland
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    private var isUptakePercentagesEngland: AnyPublisher<String, Never> {
        sut.$uptakePercentagesEngland
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    override func setUpWithError() throws {
        repository = MockRepository()
        sut = AsclepioneViewModel(repository: repository)
    }

    override func tearDownWithError() throws {
        repository = nil
        sut = nil
    }
    
    
}
