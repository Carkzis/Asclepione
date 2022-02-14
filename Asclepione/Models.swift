//
//  Models.swift
//  Asclepione
//
//  Created by Marc Jowett on 14/02/2022.
//

import Foundation

struct VaccinationData: Codable {
    let date: String
    
    let newPeopleVaccinatedFirstDoseByPublishDate: Int
    let newPeopleVaccinatedSecondDoseByPublishDate: Int
    let newPeopleVaccinatedThirdInjectionByPublishDate: Int
    let newVaccinesGivenByPublishDate: Int
    
    let cumPeopleVaccinatedFirstDoseByPublishDate: Int
    let cumPeopleVaccinatedSecondDoseByPublishDate: Int
    let cumPeopleVaccinatedThirdInjectionByPublishDate: Int
    let cumVaccinesGivenByPublishDate: Int
    
    let cumVaccinationFirstDoseUptakeByPublishDate: Int
    let cumVaccinationSecondDoseUptakeByPublishDatePercentage: Int
    let cumVaccinationThirdInjectionUptakeByPublishDatePercentage: Int
    
    let newPeopleVaccinedCompleteByVaccinationData: Int
    let cumVaccinationCompleteCoverageByPublishDataPercentage: Int
}
