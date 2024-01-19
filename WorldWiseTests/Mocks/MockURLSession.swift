//
//  MockURLSession.swift
//  WorldWiseTests
//
//  Created by Hardik Shukla on 1/18/24.
//

import Foundation
@testable import WorldWise

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    func simulate(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        completionHandler(data, response, error)
        return MockURLSessionDataTask()
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func resume() { }
}
