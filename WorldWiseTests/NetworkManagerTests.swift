//
//  NetworkManagerTests.swift
//  WorldWiseTests
//
//  Created by Hardik Shukla on 1/19/24.
//

import XCTest
@testable import WorldWise

class NetworkManagerTests: XCTestCase {

    var networkManager: NetworkManager!
    var mockSession: MockURLSession!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        networkManager = NetworkManager(session: mockSession)
    }

    override func tearDown() {
        mockSession = nil
        networkManager = nil
        super.tearDown()
    }
    
    func testFetchCountriesSuccess() {
        let jsonString = """
        [
            {
                "capital": "Kabul",
                "code": "AF",
                "currency": {
                    "code": "AFN",
                    "name": "Afghan afghani",
                    "symbol": "؋"
                },
                "flag": "https://restcountries.eu/data/afg.svg",
                "language": {
                    "code": "ps",
                    "name": "Pashto"
                },
                "name": "Afghanistan",
                "region": "AS"
            }
        ]
        """
        let expectedData = Data(jsonString.utf8)
        mockSession.simulate(data: expectedData, response: validResponse(), error: nil)

        let expectation = XCTestExpectation(description: "Successful fetch of countries")

        Task {
            do {
                let countries = try await networkManager.fetchCountries()
                XCTAssertEqual(countries.first?.name, "Afghanistan")
                expectation.fulfill()
            } catch {
                XCTFail("Expected successful fetch, received error: \(error)")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchCountriesNetworkError() {
        let expectedError = NSError(domain: "NetworkError", code: 0, userInfo: nil)
        mockSession.simulate(data: nil, response: nil, error: expectedError)

        let expectation = XCTestExpectation(description: "Network error in fetching countries")

        Task {
            do {
                _ = try await networkManager.fetchCountries()
                XCTFail("Expected network error, but succeeded")
            } catch let error as NSError {
                // Check specifics of the error
                XCTAssertEqual(error.domain, expectedError.domain)
                XCTAssertEqual(error.code, expectedError.code)
                expectation.fulfill()
            } catch {
                XCTFail("Unexpected error type: \(error)")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

}
//Helper
private func validResponse(url: URL = URL(string: "https://example.com")!) -> URLResponse {
    return HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
}
