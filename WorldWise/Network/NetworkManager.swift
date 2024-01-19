//
//  NetworkManager.swift
//  WorldWise
//
//  Created by Hardik Shukla on 1/18/24.
//

import Foundation

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed
}

class NetworkManager {
    func fetchCountries() async throws -> [Country] {
        guard let url = URL(string: "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json") else {
            throw NetworkError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let countries = try JSONDecoder().decode([Country].self, from: data)
        //print("Countries data from  network layer, \(countries)")
        return countries
    }
}

