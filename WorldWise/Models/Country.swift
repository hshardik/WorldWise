//
//  Country.swift
//  WorldWise
//
//  Created by Hardik Shukla on 1/15/24.
//

import Foundation

struct Country: Codable {
    let capital: String
    let code: String
    let currency: Currency
    let flag: String
    let language: Language
    let name: String
    let region: String
}

struct Currency: Codable {
    let code: String
    let name: String
    let symbol: String?
}

struct Language: Codable {
    let code: String?
    let name: String
}
