//
//  WeatherViewModel.swift
//  ForecastApp
//
//  Created by Cristian Costa on 01/07/2022.
//

import Foundation
import CoreLocation

protocol WeatherViewModelDelegate: AnyObject {
    func fetchWeatherSuccess(weather: WeatherModel)
    func fetchWeatherError()
}

struct WeatherViewModel {
    weak var delegate: WeatherViewModelDelegate?
    var weatherService = WeatherService()
    var weather: WeatherData?
    
    func fetch(latitude: CLLocationDegrees, longitute: CLLocationDegrees) {
        weatherService.fetchWeather(latitude: latitude, longitute: longitute) { response in
            guard let weatherModel = weatherDataToModel(response) else {return}
            self.delegate?.fetchWeatherSuccess(weather: weatherModel)
        } onError: {_ in 
            self.delegate?.fetchWeatherError()
        }
    }
    
    func weatherDataToModel(_ weatherData: WeatherData) -> WeatherModel? {
        let currentId = weatherData.current.weather[0].id
        let currentTimezone = weatherData.timezone_offset
        let currentDescription = weatherData.current.weather[0].description
        let currentTemp = weatherData.current.temp
        let currentFeelsLike = weatherData.current.feels_like
        let sunrise = weatherData.current.sunrise
        let sunset = weatherData.current.sunset
        let humidity = weatherData.current.humidity
        let pressure = weatherData.current.pressure
        
        var arrayHourlyModel = [HourlyModel]()
        var arrayDailyModel = [DailyModel]()
        
        for i in 0...weatherData.hourly.count-1 {
            let timeHourly = weatherData.hourly[i].dt
            let tempHourly = weatherData.hourly[i].temp
            let weatherHourlyId = weatherData.hourly[i].weather[0].id
            let hourlyModelInstance = HourlyModel(ti: timeHourly, temp: tempHourly, id: weatherHourlyId)
            arrayHourlyModel.append(hourlyModelInstance)
        }
        
        for i in 0...weatherData.daily.count-1 {
            let timeDaily = weatherData.daily[i].dt
            let minDaily = weatherData.daily[i].temp.min
            let maxDaily = weatherData.daily[i].temp.max
            let conditionDailyId = weatherData.daily[i].weather[0].id
            let dailyModelInstance = DailyModel(ti: timeDaily, min: minDaily, max: maxDaily, id: conditionDailyId)
            arrayDailyModel.append(dailyModelInstance)
        }
        
        let weather = WeatherModel(temp: currentTemp, id: currentId, description: currentDescription, hour: arrayHourlyModel, day: arrayDailyModel, feelsLike: currentFeelsLike, sunr: sunrise, suns: sunset, tim: currentTimezone, hum: humidity, press: pressure)
        
        return weather
    }
    
    func getCurrentDate(timeZone: Int) -> String {
        let currentDateTime = Date()
        let dateFormatterDay = DateFormatter()
        let dateFormatterMonth = DateFormatter()
        let dateFormatterYear = DateFormatter()

        
        dateFormatterDay.dateFormat = "d"
        dateFormatterMonth.dateFormat = "MM"
        dateFormatterYear.dateFormat = "y"
                
        dateFormatterDay.timeZone = TimeZone(secondsFromGMT: timeZone)
        dateFormatterMonth.timeZone = TimeZone(secondsFromGMT: timeZone)
        dateFormatterYear.timeZone = TimeZone(secondsFromGMT: timeZone)
        
        let numberDay = dateFormatterDay.string(from: currentDateTime)
        let month = dateFormatterMonth.string(from: currentDateTime)
        let year = dateFormatterYear.string(from: currentDateTime)
        
        let date = "\(month)-\(numberDay)-\(year)"
        return date
    }
}
