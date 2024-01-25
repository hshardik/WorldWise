//
//  WorldWiseApp.swift
//  WorldWise
//
//  Created by Hardik Shukla on 1/15/24.
//
// This file demonstrates how to integrate the Vungle SDK within a SwiftUI application by using a UIKit App Delegate adaptor.
import SwiftUI
import VungleAdsSDK

@main
struct WorldWiseApp: App {
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                CountriesViewControllerRepresentable()
                    .navigationTitle("Countries")
            }
        }
    }
}


