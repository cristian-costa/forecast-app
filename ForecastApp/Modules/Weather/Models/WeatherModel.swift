//
//  WeatherModel.swift
//  ForecastApp
//
//  Created by Cristian Costa on 01/07/2022.
//

import Foundation

class WeatherModel {
    private let currentTemp: Double?
    private let currentFeelsLike: Double?
    private let currentConditionId: Int?
    private let currentDescription: String?
    private let currentSunrise: Double?
    private let currentSunset: Double?
    private let timezone: Double?
    private let currentHumidity: Double?
    private let currentPressure: Double?
    
    let daily: [DailyModel]?
    let hourly: [HourlyModel]?
    
    init(temp: Double? = nil, id: Int? = nil, description: String? = nil, hour: [HourlyModel]? = nil, day: [DailyModel]? = nil, feelsLike: Double? = nil, sunr: Double? = nil, suns: Double? = nil, tim: Double? = nil, hum: Double? = nil, press: Double? = nil) {
        currentTemp = temp
        currentConditionId = id
        currentDescription = description
        daily = day
        hourly = hour
        currentFeelsLike = feelsLike
        currentSunrise = sunr
        currentSunset = suns
        timezone = tim
        currentHumidity = hum
        currentPressure = press
    }
    
    func getCurrentHumidity() -> String {
        return String(format: "%.0f", currentHumidity!)
    }
    
    func getCurrentPressure() -> String {
        return String(format: "%.0f", currentPressure!)
    }
    
    func getCurrentTemp() -> String {
        return String(format: "%.0f", currentTemp!)
    }
    
    func getCurrentFeelsLike() -> String {
        return String(format: "%.0f", currentFeelsLike!)
    }
    
    func getCurrentConditionId() -> String {
        switch currentConditionId! {
            case 200...232:
                return "cloud.bolt.rain"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            default:
                return "cloud"
        }
    }

    func getCurrentDescription() -> String {
        return currentDescription!
    }
    
    func getTimeSunrise() -> Date {
        let date = Date(timeIntervalSince1970: Double(currentSunrise!))
        return date
    }
    
    func getTimeSunset() -> Date {
        let date = Date(timeIntervalSince1970: Double(currentSunset!))
        return date
    }
    
    func getTimezone() -> Int {
        return Int(timezone!)
    }
}

class HourlyModel {
    let time: Int
    let temperature: Double
    let conditionId: Int
    
    init(ti: Int, temp: Double, id: Int ) {
        time = ti
        temperature = temp
        conditionId = id
    }

    func temperatureHourlyString() -> String {
        return " \(String(format: "%.0f", temperature))"
    }

    func conditionName() -> String {
        switch conditionId {
            case 200...232:
                return "cloud.bolt.rain"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            default:
                return "cloud"
        }
    }
    
    func getTime(timezone: Int) -> Date {
        let date = Date(timeIntervalSince1970: Double(time))
        return date
    }
    
    func getTimeDouble() -> Int {
        return time
    }
}

class DailyModel {
    let time: Int
    let minTemp: Double
    let maxTemp: Double
    let conditionId: Int
    
    init(ti: Int, min: Double, max: Double, id: Int) {
        time = ti
        minTemp = min
        maxTemp = max
        conditionId = id
    }
    
    func minTemperatureString() -> String {
        return "\(String(format: "%.0f", minTemp))°"
    }
    
    func maxTemperatureString() -> String {
        return "\(String(format: "%.0f", maxTemp))°"
    }
    
    func getTime(timezoneGMT: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(time))

        let dateFormatterNameDay = DateFormatter()
        let dateFormatterDay = DateFormatter()
        dateFormatterDay.dateFormat = "d MMM"
        dateFormatterNameDay.dateFormat = "EEEE"
    
        dateFormatterDay.timeZone = TimeZone(secondsFromGMT: timezoneGMT)
        dateFormatterNameDay.timeZone = TimeZone(secondsFromGMT: timezoneGMT)
        
        var dayInWeek = dateFormatterNameDay.string(from: date)
        let numberDay = dateFormatterDay.string(from: date)
        
        switch dayInWeek {
            case "lunes":
                dayInWeek = "Mon \(numberDay)"
            case "martes":
                dayInWeek = "Tue \(numberDay)"
            case "miércoles":
                dayInWeek = "Wed \(numberDay)"
            case "jueves":
                dayInWeek = "Thu \(numberDay)"
            case "viernes":
                dayInWeek = "Fri \(numberDay)"
            case "sábado":
                dayInWeek = "Sat \(numberDay)"
            case "domingo":
                dayInWeek = "Sun \(numberDay)"
            default:
                dayInWeek = "Mon \(numberDay)"
        }
        return dayInWeek
    }
    
    func conditionName() -> String {
        switch conditionId {
            case 200...232:
                return "cloud.bolt.rain"
            case 300...321:
                return "cloud.rain"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            default:
                return "cloud"
        }
    }
}
