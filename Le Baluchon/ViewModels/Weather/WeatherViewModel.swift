//
//  WeatherViewModel.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 03/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation
import UIKit

class WeatherViewModel {
    
    let weather: TodayWeather
    
    let city: String
    let temp: String
    let description: String
    let day: String
    
    var weatherCondition: WeatherCondition = .none
        
    init(weather: TodayWeather) {
        self.weather = weather
        self.city = weather.name
        self.temp = WeatherViewModel.formatTemp(for: weather)
        self.weatherCondition = WeatherViewModel.formatWeatherCondition(for: weather)
        self.description = WeatherViewModel.formatDescription(for: weather)
        self.day = Date.getDayString()
    }
    
    private static func formatTemp(for weather: TodayWeather) -> String {
        let roundedWeather = Int(round(weather.main.temp))
        return String(roundedWeather) + "°"
    }
    
    private static func formatWeatherCondition(for weather: TodayWeather) -> WeatherCondition {
        
        for conditions in weather.weather {
            switch conditions.icon {
            case "01d":
                return .clearSkyD
            case "01n":
                return .clearSkyN
            case "02d":
                return .fewCloudsD
            case "02n":
                return.fewCloudsN
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
                break
            }
        }
        return .none
    }
    
    private static func formatDescription(for weather: TodayWeather) -> String {
        return weather.weather.first?.description ?? ""
    }
        
    func configure(imageView: UIImageView,
                   cityLabel: UILabel,
                   tempLabel: UILabel,
                   descriptionLabel: UILabel,
                   dayLabel: UILabel) {
        
        let image = weatherCondition.image
        imageView.image = image
        imageView.image = image.aspectFitImage(inRect: imageView.frame)
        imageView.contentMode = .right
        cityLabel.text = city
        tempLabel.text = temp
        descriptionLabel.text = description
        dayLabel.text = day
    }
}
