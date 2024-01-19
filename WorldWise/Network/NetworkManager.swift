//
//  NetworkManager.swift
//  WorldWise
//
//  Created by Hardik Shukla on 1/18/24.
//

import Foundation

import Foundation

// Protocol to simulate network responses
protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

// Extend the existing URLSession to conform to your protocol
extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let task: URLSessionDataTask = dataTask(with: url, completionHandler: completionHandler)
        return task as URLSessionDataTaskProtocol
    }
}

// Extend URLSessionDataTask to conform to URLSessionDataTaskProtocol
extension URLSessionDataTask: URLSessionDataTaskProtocol {}

protocol NetworkManagerProtocol {
    func fetchCountries() async throws -> [Country]
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed
}

class NetworkManager: NetworkManagerProtocol {
    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetchCountries() async throws -> [Country] {
        guard let url = URL(string: "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json") else {
            throw NetworkError.invalidURL
        }

        return try await withCheckedThrowingContinuation { continuation in
            session.dataTask(with: url) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    continuation.resume(throwing: NetworkError.requestFailed)
                    return
                }

                guard let data = data else {
                    continuation.resume(throwing: NetworkError.requestFailed)
                    return
                }

                do {
                    let countries = try JSONDecoder().decode([Country].self, from: data)
                    continuation.resume(returning: countries)
                } catch {
                    continuation.resume(throwing: error)
                }
            }.resume()
        }
    }
}


