//
//  Models.swift
//  Asclepione
//
//  Created by Marc Jowett on 14/02/2022.
//

import Foundation
import Alamofire

struct ResponseDTO: Decodable, EmptyResponse {
    static func emptyValue() -> ResponseDTO {
        return ResponseDTO(data: nil)
    }
    
    var data: [VaccinationDataDTO]? = nil
    
}

struct VaccinationDataDTO: Decodable {
    let date: String

    let newPeopleWithFirstDose: Int?
    let newPeopleWithSecondDose: Int?
    let newPeopleWithThirdDose: Int?
    let newVaccinations: Int?

    let cumulativeFirstDoses: Int?
    let cumulativeSecondDoses: Int?
    let cumulativeThirdDoses: Int?
    let cumulativeVaccinations: Int?

    let firstDoseUptakePercentage: Float?
    let secondDoseUptakePercentage: Float?
    let thirdDoseUptakePercentage: Float?

    enum CodingKeys: String, CodingKey {
        case date = "date"

        case newPeopleWithFirstDose = "newPeopleVaccinatedFirstDoseByPublishDate"
        case newPeopleWithSecondDose = "newPeopleVaccinatedSecondDoseByPublishDate"
        case newPeopleWithThirdDose = "newPeopleVaccinatedThirdInjectionByPublishDate"
        case newVaccinations = "newVaccinesGivenByPublishDate"
      
        case cumulativeFirstDoses = "cumPeopleVaccinatedFirstDoseByPublishDate"
        case cumulativeSecondDoses = "cumPeopleVaccinatedSecondDoseByPublishDate"
        case cumulativeThirdDoses = "cumPeopleVaccinatedThirdInjectionByPublishDate"
        case cumulativeVaccinations = "cumVaccinesGivenByPublishDate"

        case firstDoseUptakePercentage = "cumVaccinationFirstDoseUptakeByPublishDatePercentage"
        case secondDoseUptakePercentage = "cumVaccinationSecondDoseUptakeByPublishDatePercentage"
        case thirdDoseUptakePercentage = "cumVaccinationThirdInjectionUptakeByPublishDatePercentage"
    }

}
