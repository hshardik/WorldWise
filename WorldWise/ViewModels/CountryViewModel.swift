//
//  CountryViewModel.swift
//  WorldWise
//
//  Created by Hardik Shukla on 1/15/24.
//

import Foundation

@MainActor
class CountryViewModel {
    @Published var countries: [Country] = []
    @Published var filteredCountries: [Country] = []

    var networkManager = NetworkManager()

    func fetchCountries() async {
        do {
            countries = try await networkManager.fetchCountries()
            filteredCountries = countries
        } catch {
            print(error)
        }
    }

    func search(for query: String) {
        if query.isEmpty {
            filteredCountries = countries
        } else {
            filteredCountries = countries.filter {
                $0.name.localizedCaseInsensitiveContains(query) ||
                $0.capital.localizedCaseInsensitiveContains(query)
            }
        }
    }
    
    func resetSearch() {
        filteredCountries = countries
    }
}



