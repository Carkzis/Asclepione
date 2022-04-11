//
//  DomainObjects.swift
//  Asclepione
//
//  Created by Marc Jowett on 28/03/2022.
//

import Foundation

/*
 Domain objects holding vaccination data for use with the UI.
 */

/**
 Domain object for new vaccinations in a given day.
 */
struct NewVaccinationsDomainObject {
    var country: String?
    var date: Date?
    var newVaccinations: Int?
}

/**
 Domain object  for cumulative vaccinations given by a certain day.
 */
struct CumulativeVaccinationsDomainObject {
    var country: String?
    var date: Date?
    var cumulativeVaccinations: Int?
}

/**
 Domain object for vaccination uptake for a given area by a given day.
 */
struct UptakePercentageDomainObject {
    var country: String?
    var date: Date?
    var thirdDoseUptakePercentage: Int?
}
