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
    
    var newVaccinationsEntities: [MockNewVaccinations] = []
    var cumulativeVaccinationsEntities: [CumulativeVaccinations] = []
    var uptakePercentages: [UptakePercentages] = []
    
    func refreshVaccinationData() {
        if networkError == true {
            print("There was a network error.")
        } else {
            responseData = ResponseDTO.retrieveResponseData(amountOfItems: 4)
            convertDTOtoEntities(dto: responseData!)
        }
    }
    
    func convertDTOtoEntities(dto: ResponseDTO) {
        let unwrappedDTO = unwrapDTO(dtoToUnwrap: dto)
        newVaccinationsEntities = unwrappedDTO.map {
            let vaccination = MockNewVaccinations()
            vaccination.id = createReproducibleUniqueID(date: $0.date, areaType: $0.date)
            vaccination.areaName = $0.areaName
            vaccination.date = transformStringIntoDate(dateAsString: $0.date)
            vaccination.newFirstDoses = Int16($0.newPeopleWithFirstDose!)
            vaccination.newSecondDoses = Int16($0.newPeopleWithSecondDose!)
            vaccination.newThirdDoses = Int16($0.newPeopleWithThirdDose!)
            vaccination.newVaccinations = Int16($0.newVaccinations!)
            return vaccination
        }
    }
    
    private func unwrapDTO(dtoToUnwrap: ResponseDTO) -> [VaccinationDataDTO] {
        if let unwrappedDTO = dtoToUnwrap.data {
            return unwrappedDTO
        } else {
            return []
        }
    }
    
    private func createReproducibleUniqueID(date: String, areaType: String) -> String {
        return "\(date)\(areaType)"
    }
    
    private func transformStringIntoDate(dateAsString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_UK")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // TODO: May be better to throw an error here.
        if let date = dateFormatter.date(from: dateAsString) {
            return date
        } else {
            let defaultDate = "1900-01-01"
            return dateFormatter.date(from: defaultDate)!
        }
    }
    
    
}
