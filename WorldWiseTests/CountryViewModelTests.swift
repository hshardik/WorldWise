//
//  CountryViewModelTests.swift
//  WorldWiseTests
//
//  Created by Hardik Shukla on 1/19/24.
//

import XCTest
@testable import WorldWise

class CountryViewModelTests: XCTestCase {
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

    var viewModel: CountryViewModel!
    var mockNetworkManager: MockNetworkManager!

    @MainActor override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        mockNetworkManager.data = Data(jsonString.utf8)
        viewModel = CountryViewModel(networkManager: mockNetworkManager)
    }

    override func tearDown() {
        mockNetworkManager = nil
        viewModel = nil
        super.tearDown()
    }

    
    func testJSONDecoding() {
        let data = Data(jsonString.utf8)
        XCTAssertNoThrow(try JSONDecoder().decode([Country].self, from: data))
    }

    func testFetchCountriesSuccess() {
        let expectation = XCTestExpectation(description: "Fetch countries success")

        Task {
            await viewModel.fetchCountries()

            DispatchQueue.main.async {
                XCTAssertEqual(self.viewModel.countries.count, 1)
                XCTAssertEqual(self.viewModel.countries.first?.name, "Afghanistan")
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchCountriesFailure() {
        mockNetworkManager.error = NSError(domain: "NetworkError", code: -1, userInfo: nil)

        let expectation = XCTestExpectation(description: "Fetch countries failure")

        Task {
            await viewModel.fetchCountries()

            DispatchQueue.main.async {
                XCTAssertTrue(self.viewModel.countries.isEmpty)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

}

