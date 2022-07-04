//
//  SearchViewModel.swift
//  ForecastApp
//
//  Created by Cristian Costa on 03/07/2022.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
    func fetchCitySuccess(city: [CityModel])
    func fetchCityError()
}

struct SearchViewModel {
    weak var delegate: SearchViewModelDelegate?
    var searchService = SearchService()

    
    func fetch(city: String) {
        searchService.fetchCity(city: city) { response in
            guard let cityModel = cityDataToModel(response) else {return}
            delegate?.fetchCitySuccess(city: cityModel)
        } onError: { _ in
            delegate?.fetchCityError()
        }
    }
    
    func cityDataToModel(_ cityData: CityData) -> [CityModel]? {
        var cityArray = [CityModel]()
        for i in 0...cityData.features.count-1 {
            let placeName = cityData.features[i].place_name
            let longitude = cityData.features[i].center[0]
            let latitude = cityData.features[i].center[1]

            let cityInstance = CityModel(city: placeName, long: longitude, lat: latitude)
            cityArray.append(cityInstance)
        }
        return cityArray
    }
}
