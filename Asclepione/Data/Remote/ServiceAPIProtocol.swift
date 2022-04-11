//
//  ServiceAPIProtocol.swift
//  Asclepione
//
//  Created by Marc Jowett on 18/02/2022.
//

import Foundation
import Combine
import Alamofire

/**
 Protocol for handling retrieval of data from a REST API.
 */
protocol ServiceAPIProtocol {
    func retrieveFromWebAPI(area: AreaName) -> AnyPublisher<DataResponse<ResponseDTO, AFError>, Never>
}

extension ServiceAPIProtocol {
    /**
     Retrieves data from a REST API. The default area is England, but alternatives (Scotland, Northern Irelad and Wale) can be supplied.
     */
    func retrieveFromWebAPI(_ areaName: AreaName = .england) -> AnyPublisher<DataResponse<ResponseDTO, AFError>, Never> {
        return retrieveFromWebAPI(area: areaName)
    }
}
