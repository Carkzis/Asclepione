//
//  DataUtils.swift
//  Asclepione
//
//  Created by Marc Jowett on 08/03/2022.
//

import Foundation

/*
 Utility classes for dealing with data transformation.
 */

/**
 Unwraps the vaccination data from the ResponseDTO obtained from the REST API.
 */
func unwrapDTO(dtoToUnwrap: ResponseDTO) -> [VaccinationDataDTO] {
    if let unwrappedDTO = dtoToUnwrap.data {
        return unwrappedDTO
    } else {
        return []
    }
}

/**
 Creates a unique ID given a date and an area name, effectively concatenating them together.
 This assumes that the REST API is only updated with new data once a day.
 */
func createReproducibleUniqueID(date: String, areaName: String) -> String {
    return "\(date)\(areaName)"
}

/**
 Transforms a date in a String format of "yyyy-MM-dd" into a date in a Date format.
 */
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

/**
 Transforms a date in a Date format into a date in a String format of "dd-MM-yyyy".
 */
func transformDateIntoString(dateAsDate: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_UK")
    dateFormatter.dateFormat = "dd-MM-yyyy"
    
    return dateFormatter.string(from: dateAsDate)
}

/**
 Formats an Int as a decimal style String e.g. 1000 becomes "1,000". Returns "0" if the formatted value is nil.
 */
func formatNumberAsDecimalStyle(numberToFormat: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = NumberFormatter.Style.decimal
    return(numberFormatter.string(from: NSNumber(value: numberToFormat)) ?? "0")
}
