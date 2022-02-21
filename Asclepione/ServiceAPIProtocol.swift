//
//  ServiceAPIProtocol.swift
//  Asclepione
//
//  Created by Marc Jowett on 18/02/2022.
//

import Foundation
import Combine
import Alamofire

protocol ServiceAPIProtocol {
    func retrieveFromWebAPI(area: AreaName) -> AnyPublisher<DataResponse<ResponseDTO, AFError>, Never>
}

extension ServiceAPIProtocol {
    func retrieveFromWebAPI(_ areaName: AreaName = .england) -> AnyPublisher<DataResponse<ResponseDTO, AFError>, Never> {
        return retrieveFromWebAPI(area: areaName)
    }
}
