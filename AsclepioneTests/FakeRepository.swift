//
//  FakeRepository.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 04/03/2022.
//

import Foundation
@testable import Asclepione

class FakeRepository: RepositoryProtocol {
    var networkError = false
    var responseData: ResponseDTO? = nil
    
    func refreshVaccinationData() {
        if networkError == true {
            print("There was a network error.")
        } else {
            responseData = ResponseDTO.retrieveResponseData(amountOfItems: 4)
        }
    }
    
}
