//
//  CountriesViewControllerRepresentable.swift
//  WorldWise
//
//  Created by Hardik Shukla on 1/18/24.
//

import SwiftUI
import UIKit

struct CountriesViewControllerRepresentable: UIViewControllerRepresentable {
    
    // This method creates and returns the appropriate UIKit view controller.
    func makeUIViewController(context: Context) -> UINavigationController {
        let countriesViewController = CountriesViewController()
        let navigationController = UINavigationController(rootViewController: countriesViewController)
        return navigationController
    }
    
    // This method updates the view controller with new data.
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // If there's any data that needs to be updated in CountriesViewController, do it here.
        // For example, you might want to pass new data to the view model.
    }
}

