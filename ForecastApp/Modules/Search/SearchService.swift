//
//  CityService.swift
//  ForecastApp
//
//  Created by Cristian Costa on 03/07/2022.
//

import Foundation

struct SearchService {
    let baseURL = ProcessInfo.processInfo.environment["baseURLLocation"] ?? "https://api.mapbox.com/geocoding/v5/mapbox.places/"
    let apiKey = ProcessInfo.processInfo.environment["apiKeyLocation"] ?? "pk.eyJ1IjoiY3Jpc3RpYW5jb3N0YTk0IiwiYSI6ImNrcGFmNHBweDBwMmoyeW11bnhhZXB6M3gifQ.olOZwocaBmIv7JsK924Cyg"
    
    func fetchCity(city: String, onComplete: @escaping (CityData) -> (), onError: @escaping (String) -> ()) {
        ApiManager.shared.get(url: "\(baseURL)\(city).json?access_token=\(apiKey)") { response in
            switch response {
            case .success(let data):
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(CityData.self, from: data)
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
