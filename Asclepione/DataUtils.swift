//
//  DataUtils.swift
//  Asclepione
//
//  Created by Marc Jowett on 08/03/2022.
//

import Foundation

func unwrapDTO(dtoToUnwrap: ResponseDTO) -> [VaccinationDataDTO] {
    if let unwrappedDTO = dtoToUnwrap.data {
        return unwrappedDTO
    } else {
        return []
    }
}

func createReproducibleUniqueID(date: String, areaName: String) -> String {
    return "\(date)\(areaName)"
}

func transformStringIntoDate(dateAsString: String) -> Date {
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
