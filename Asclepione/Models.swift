//
//  Models.swift
//  Asclepione
//
//  Created by Marc Jowett on 14/02/2022.
//

import Foundation

struct ResponseData: Decodable {
    var data: [VaccinationData]? = nil
}

struct VaccinationData: Decodable {
    let date: String
    let newVaccinationsData: NewVaccinationsData
    let cumulativeVaccinationData: CumulativeVaccinationsData
    let cumulativeVaccinationPercentageData: CumulativeVaccinationPercentageData
}

struct NewVaccinationsData: Decodable {
    let newPeopleWithFirstDose: Int?
    let newPeopleWithSecondDose: Int?
    let newPeopleWithThirdDose: Int?
    let newVaccinations: Int?
    let newPeopleFullyVaccinated: Int?
    
    enum CodingKeys: String, CodingKey {
        case newPeopleWithFirstDose = "newPeopleVaccinatedFirstDoseByPublishDate"
        case newPeopleWithSecondDose = "newPeopleVaccinatedSecondDoseByPublishDate"
        case newPeopleWithThirdDose = "newPeopleVaccinatedThirdInjectionByPublishDate"
        case newVaccinations = "newVaccinesGivenByPublishDate"
        case newPeopleFullyVaccinated = "newPeopleVaccinedCompleteByVaccinationData"
    }
}

struct CumulativeVaccinationsData: Decodable {
    let cumulativeFirstDoses: Int?
    let cumulativeSecondDoses: Int?
    let cumulativeThirdDoses: Int?
    let cumulativeVaccinations: Int?
    let cumulativeFullyVaccinated: Int?
    
    enum CodingKeys: String, CodingKey {
        case cumulativeFirstDoses = "cumPeopleVaccinatedFirstDoseByPublishDate"
        case cumulativeSecondDoses = "cumPeopleVaccinatedSecondDoseByPublishDate"
        case cumulativeThirdDoses = "cumPeopleVaccinatedThirdInjectionByPublishDate"
        case cumulativeVaccinations = "cumVaccinesGivenByPublishDate"
        case cumulativeFullyVaccinated = "cumPeopleVaccineCompleteByPublishDate"
    }
}

struct CumulativeVaccinationPercentageData: Decodable {
    let firstDoseUptakePercentage: Int?
    let secondDoseUptakePercentage: Int?
    let thirdDoseUptakePercentage: Int?
    let fullyVaccinatedPercentage: Int?
    
    enum CodingKeys: String, CodingKey {
        case firstDoseUptakePercentage = "cumVaccinationFirstDoseUptakeByPublishDate"
        case secondDoseUptakePercentage = "cumVaccinationSecondDoseUptakeByPublishDatePercentage"
        case thirdDoseUptakePercentage = "cumVaccinationThirdInjectionUptakeByPublishDatePercentage"
        case fullyVaccinatedPercentage = "cumVaccinationCompleteCoverageByPublishDataPercentage"
    }
}
