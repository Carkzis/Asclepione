//
//  FakeURLProtocol.swift
//  AsclepioneTests
//
//  Created by Marc Jowett on 18/02/2022.
//

import Foundation

class FakeURLProtocol: URLProtocol {
    
    private var currentTask: URLSessionTask?
    static var response: MockResponse!
    
    /**
     If this returns true, it means we can alter the response.
     */
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    /**
     Returns a cononical version of the given request.
     */
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    /**
     Indicates whether two requests are equivalent for cache purposes.
     */
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    /**
     Cancel the current task as soon as we start loading it, as we don't want to run a network request.
     */
    override func startLoading() {
        currentTask?.cancel()
    }
    
    /**
     Stop loading a task.
     */
    override func stopLoading() {
        currentTask?.cancel()
    }
    
    /**
     Change the mocked response to a generic error.
     */
    static func responseWithErrors() {
        FakeURLProtocol.response = MockResponse.error(MockError.somethingWrong)
    }

    /**
     Change the mocked response to a particular status code.
     */
    static func responseWithCode(code: Int) {
        let httpResponse = HTTPURLResponse(url: URL(string: "http://a.website.com")!, statusCode: code, httpVersion: nil, headerFields: nil)!
        FakeURLProtocol.response = MockResponse.success(httpResponse)
    }
}

extension FakeURLProtocol: URLSessionDataDelegate {
    /**
     This will indicate to the client that the protocol implementation did load the data.
     */
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
    }
    
    /**
     This will be called after we cancel the request in startLoading(), and informs the client that the protocol implementation finished loading.
     */
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        client?.urlProtocolDidFinishLoading(self)
    }
}

