//
//  MockNetworkManager.swift
//  WorldWiseTests
//
//  Created by Hardik Shukla on 1/19/24.
//

import Foundation
@testable import WorldWise

class MockNetworkManager: NetworkManagerProtocol {
    var data: Data?
    var error: Error?

    func fetchCountries() async throws -> [Country] {
        // Your mock implementation
        if let error = error {
            throw error
        }
        return try JSONDecoder().decode([Country].self, from: data ?? Data())
    }
}

