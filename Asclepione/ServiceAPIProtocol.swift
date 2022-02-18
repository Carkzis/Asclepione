//
//  ServiceAPIProtocol.swift
//  Asclepione
//
//  Created by Marc Jowett on 18/02/2022.
//

import Foundation

protocol ServiceAPIProtocol {
    func retrieveFromWebAPI(completion: @escaping (Result<Data?, Error>) -> Void)
}
