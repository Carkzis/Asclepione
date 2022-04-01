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
    
    if let date = dateFormatter.date(from: dateAsString) {
        return date
    } else {
        let defaultDate = "1900-01-01"
        return dateFormatter.date(from: defaultDate)!
    }
}

func transformDateIntoString(dateAsDate: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_UK")
    dateFormatter.dateFormat = "dd-MM-yyyy"
    
    return dateFormatter.string(from: dateAsDate)
}

func formatNumberAsDecimalStyle(numberToFormat: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = NumberFormatter.Style.decimal
    return(numberFormatter.string(from: NSNumber(value: numberToFormat)) ?? "0")
}
