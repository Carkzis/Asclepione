//
//  SpyServiceAPI.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 18/02/2022.
//

import Foundation
@testable import Asclepione

class SpyServiceAPI: ServiceAPIProtocol {
    func retrieveFromWebAPI(completion: @escaping (Result<Any?, Error>) -> Void) {
        completion(.success(nil))
    }
}
