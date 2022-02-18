//
//  TestUtils.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 18/02/2022.
//

import Foundation

/**
 Enum for the type of response we receive.
 */
enum MockResponse {
    case error(Error)
    case success(HTTPURLResponse)
}

/**
 Enum for errors return in test HTTP requests.
 */
enum MockError: Error {
    case somethingWrong
}
