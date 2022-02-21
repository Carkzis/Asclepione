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
//    func retrieveFromWebAPI(completion: @escaping (Result<Any?, Error>) -> Void)
    func retrieveFromWebAPI(area: AreaName) -> AnyPublisher<DataResponse<Any?, Error>, Never>
}

extension ServiceAPIProtocol {
    func retrieveFromWebAPI(_ areaName: AreaName = .england) -> AnyPublisher<DataResponse<Any?, Error>, Never> {
        return retrieveFromWebAPI(area: areaName)
    }
}