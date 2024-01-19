//
//  ContentView.swift
//  WorldWise
//
//  Created by Hardik Shukla on 1/15/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            CountriesViewControllerRepresentable()
                .navigationTitle("Countries")
                .edgesIgnoringSafeArea(.bottom) // If you want your view controller to extend under the navigation bar
        }
    }
}

#Preview {
    ContentView()
}
