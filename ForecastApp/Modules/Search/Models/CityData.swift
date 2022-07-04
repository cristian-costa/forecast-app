//
//  CityData.swift
//  ForecastApp
//
//  Created by Cristian Costa on 03/07/2022.
//

import Foundation

struct CityData: Codable {
    let features: [Features]
}

struct Features: Codable {
    let place_name: String
    let center: [Double]
}
