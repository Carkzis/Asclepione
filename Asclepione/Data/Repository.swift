//
//  Repository.swift
//  Asclepione
//
//  Created by Marc Jowett on 11/04/2022.
//

import Foundation

/**
 Protocol for mediating data flow between the remote and local stores, and the UI.
 */
protocol Repository {
    func refreshVaccinationData()
    var newVaccinationsPublisher: Published<NewVaccinationsDomainObject>.Publisher { get }
    var cumVaccinationsPublisher: Published<CumulativeVaccinationsDomainObject>.Publisher { get }
    var uptakePercentagesPublisher: Published<UptakePercentageDomainObject>.Publisher { get }
    var isLoadingPublisher: Published<Bool>.Publisher { get }
}

extension Repository {
    func insertResultsIntoLocalDatabase() {}
}
