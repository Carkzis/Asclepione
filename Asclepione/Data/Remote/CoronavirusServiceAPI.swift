//
//  CoronavirusAPI.swift
//  Asclepione
//
//  Created by Marc Jowett on 18/02/2022.
//

import Foundation
import Alamofire
import Combine

class CoronavirusServiceAPI: ServiceAPIProtocol {
    
    private let SUCCESS_CODE = 200
    private let url = "https://api.coronavirus.data.gov.uk/v1/data"
    
    /**
     This is an Alamofire Session.
     */
    private let sessionManager: Session
    
    init(sessionManager: Session = Session.default) {
        self.sessionManager = sessionManager
    }
    
    /**
     Returns the latest result for an area (country) of the UK from the Coronavirus Open Data API (APIv1).
     */
    private func getParametersForArea(_ areaName: AreaName = .england) -> Parameters {
        let areaType = "nation"
        let filters = "areaType=\(areaType);areaName=\(areaName.description)"
        let latestBy = "newVaccinesGivenByPublishDate"
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
            "structure": "\(structure)",
            "latestBy": "\(latestBy)"
        ]
        return parameters
    }
    
    /*
     The data response, either a ResponseDTO or an AFError, will be published as the output.  The failure
     type is never, as the network error is contained in the output.
     */
    func retrieveFromWebAPI(area: AreaName = .england) -> AnyPublisher<DataResponse<ResponseDTO, AFError>, Never> {
        return sessionManager.request(url, method: .get, parameters: getParametersForArea(), encoding: URLEncoding.default, headers: nil)
            .validate()
            .publishDecodable(type: ResponseDTO.self, emptyResponseCodes: [SUCCESS_CODE]) // Allows an empty 200 response.
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}

enum AreaName {
    case england
    case scotland
    case ni
    case wales
    
    var description: String {
        switch self {
        case .england: return "England"
        case .scotland: return "Scotland"
        case .ni: return "Northern Ireland"
        case .wales: return "Wales"
        }
    }
}
