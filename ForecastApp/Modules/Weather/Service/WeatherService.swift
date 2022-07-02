//
//  WeatherService.swift
//  ForecastApp
//
//  Created by Cristian Costa on 01/07/2022.
//

import Foundation
import CoreLocation

struct WeatherService {
    let baseURL = ProcessInfo.processInfo.environment["baseURL"] ?? "https://api.openweathermap.org/data/2.5/onecall?exclude=minutely&units=metric&lang=es&"
    let apiKey = ProcessInfo.processInfo.environment["apiKey"] ?? "29af9d657d409e90b699b86e4fe0e4b3"
    
    func fetchWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees, onComplete: @escaping (WeatherData) -> (), onError: @escaping (String) -> ()) {
        ApiManager.shared.get(url: "\(baseURL)appid=\(apiKey)&lat=\(latitude)&lon=\(longitute)") { response in
            switch response {
            case .success(let data):
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(WeatherData.self, from: data)
                        onComplete(response)
                    } else {
                        onError("Error")
                    }
                } catch {
                    onError("Error")
                }
            case .failure(_):
                onError("Error")
            }
        }
    }
}
