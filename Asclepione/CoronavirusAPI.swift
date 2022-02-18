//
//  CoronavirusAPI.swift
//  Asclepione
//
//  Created by Marc Jowett on 18/02/2022.
//

import Foundation
import Alamofire

class CoronavirusAPI {
    
    /**
     This is an Alamofire Session.
     */
    private let sessionManager: Session
    
    init(sessionManager: Session = Session.default) {
        self.sessionManager = sessionManager
    }
    
    let url = "https://api.coronavirus.data.gov.uk/v1/data"

    private func getParameters() -> Parameters {
        let filters = "areaType=nation"
        let structure =
            ["newPeopleVaccinatedFirstDoseByPublishDate",
            "newPeopleVaccinatedSecondDoseByPublishDate",
            "newPeopleVaccinatedThirdInjectionByPublishDate",
            "newVaccinesGivenByPublishDate",
            "newPeopleVaccinatedCompleteByVaccinationDate",

            "cumPeopleVaccinatedFirstDoseByPublishDate",
            "cumPeopleVaccinatedSecondDoseByPublishDate",
            "cumPeopleVaccinatedThirdInjectionByPublishDate",
            "cumVaccinesGivenByPublishDate",
            "cumPeopleVaccinatedCompleteByVaccinationDate",
            
            "cumVaccinationFirstDoseUptakeByPublishDatePercentage",
            "cumVaccinationSecondDoseUptakeByPublishDatePercentage",
            "cumVaccinationThirdInjectionUptakeByPublishDatePercentage",
            "cumVaccinationCompleteCoverageByVaccinationDatePercentage"]
            
        let parameters: Parameters = [
            "filters": "\(filters)",
            "structure": "\(structure)"
        ]
        return parameters
    }
    
    func retrieveFromWebAPI() {
        sessionManager.request(url, method: .get, parameters: getParameters(), encoding: URLEncoding.default, headers: nil)
            .response { (response) in
                // Need to sort this out.
                print(response.data!)
            }
    }
    
}
