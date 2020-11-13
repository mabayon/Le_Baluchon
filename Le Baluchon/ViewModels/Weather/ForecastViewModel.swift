//
//  ForecastViewModel.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 05/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation

class ForecastViewModel {
    let forecast: List
    let day: String
    let tempMax: String
    let tempMin: String
    let weatherCondition: WeatherCondition
    
    init(forecast: List, temps: Temp) {
        self.forecast = forecast
        day = ForecastViewModel.getDay(from: forecast)
        weatherCondition = ForecastViewModel.formatWeatherCondition(for: forecast)
        tempMax = String(temps.max)
        tempMin = String(temps.min)
    }
    
    private static func getDay(from list: List) -> String {
        let dateString = String(list.dt_txt.split(separator: " ").first ?? "")
        let date = Date().fromString(dateString)
        return Date.getDayString(for: date)
    }
    
    private static func formatWeatherCondition(for forecast: List) -> WeatherCondition {
                
        for weather in forecast.weather {
            switch weather.icon {
            case "01d", "01n":
                return .clearSky
            case "02d", "02n":
                return .fewClouds
            case "03d", "03n", "04d", "04n":
                return .clouds
            case "09d", "09n", "10d", "10n":
                return .rain
            case "11d", "11n":
                return .thunderstorm
            case "13d", "13n":
                return .snow
            case "50d", "50n":
                return .mist
            default:
                return .none
            }
        }
        return .none
    }
        
        func configure(_ cell: ForecastTableViewCell) {
            cell.dayLabel.text = day
            cell.weatherImage.image = weatherCondition.image
            cell.tempMaxLabel.text = tempMax
            cell.tempMinLabel.text = tempMin
        }
}
