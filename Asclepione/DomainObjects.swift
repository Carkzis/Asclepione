//
//  DomainObjects.swift
//  Asclepione
//
//  Created by Marc Jowett on 28/03/2022.
//

import Foundation

// TODO: Add domain objects.

struct NewVaccinationsDomainObject {
    var date: Date
    var newVaccinations: Int
}

struct CumulativeVaccinationsDomainObject {
    var date: Date
    var cumulativeVaccinations: Int
}

struct UptakePercentageDomainObject {
    var date: Date
    var thirdDoseUptakePercentage: Int
}
