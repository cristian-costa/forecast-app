//
//  WeatherData.swift
//  ForecastApp
//
//  Created by Cristian Costa on 01/07/2022.
//

import Foundation

struct WeatherData: Codable {
    let current: Current
    let timezone_offset: Double
    let hourly: [Hourly]
    let daily: [Daily]
}

struct Current: Codable {
    let temp: Double
    let feels_like: Double
    let weather: [Weather]
    let sunrise: Double
    let sunset: Double
    let humidity: Double
    let pressure: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
}

struct Hourly: Codable {
    let dt: Int
    let temp: Double
    let weather: [Weather]
}

struct Daily: Codable {
    let dt: Int
    let temp: Temp
    let weather: [Weather]
}

struct Temp: Codable {
    let min: Double
    let max: Double
}
