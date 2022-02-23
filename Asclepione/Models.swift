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
    let newPeopleFullyVaccinated: Int?

    let cumulativeFirstDoses: Int?
    let cumulativeSecondDoses: Int?
    let cumulativeThirdDoses: Int?
    let cumulativeVaccinations: Int?
    let cumulativeFullyVaccinated: Int?

    let firstDoseUptakePercentage: Float?
    let secondDoseUptakePercentage: Float?
    let thirdDoseUptakePercentage: Float?
    let fullyVaccinatedPercentage: Float?

    enum CodingKeys: String, CodingKey {
        case date = "date"

        case newPeopleWithFirstDose = "newPeopleVaccinatedFirstDoseByPublishDate"
        case newPeopleWithSecondDose = "newPeopleVaccinatedSecondDoseByPublishDate"
        case newPeopleWithThirdDose = "newPeopleVaccinatedThirdInjectionByPublishDate"
        case newVaccinations = "newVaccinesGivenByPublishDate"
        // This is England and Scotland only, the other countries use "newPeopleVaccinatedCompleteByPublishDate".
        case newPeopleFullyVaccinated = "newPeopleVaccinatedCompleteByVaccinationDate"

        case cumulativeFirstDoses = "cumPeopleVaccinatedFirstDoseByPublishDate"
        case cumulativeSecondDoses = "cumPeopleVaccinatedSecondDoseByPublishDate"
        case cumulativeThirdDoses = "cumPeopleVaccinatedThirdInjectionByPublishDate"
        case cumulativeVaccinations = "cumVaccinesGivenByPublishDate"
        // This is England and Scotland only, the other countries use "newPeopleVaccinatedCompleteByPublishDate".
        case cumulativeFullyVaccinated = "cumPeopleVaccinatedCompleteByVaccinationDate"

        case firstDoseUptakePercentage = "cumVaccinationFirstDoseUptakeByPublishDatePercentage"
        case secondDoseUptakePercentage = "cumVaccinationSecondDoseUptakeByPublishDatePercentage"
        case thirdDoseUptakePercentage = "cumVaccinationThirdInjectionUptakeByPublishDatePercentage"
        // This is England and Scotland only, the other countries use "newPeopleVaccinatedCompleteByPublishDate".
        case fullyVaccinatedPercentage = "cumVaccinationCompleteCoverageByVaccinationDatePercentage"
    }

}
