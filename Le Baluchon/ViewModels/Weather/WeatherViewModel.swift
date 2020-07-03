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
    
    enum WeatherCondition {
        case clearSkyD, clearSkyN, thunderstorm,
        clouds, fewCloudsD, fewCloudsN, mist, rain, snow, none
        
        var image: UIImage {
            let imageName: String
            switch self {
            case .clearSkyD:
                imageName = "weather_clear_sky_d"
            case .clearSkyN:
                imageName = "weather_clear_sky_n"
            case .thunderstorm:
                imageName = "weather_thunderstorm"
            case .clouds:
                imageName = "weather_clouds"
            case .fewCloudsD:
                imageName = "weather_few_clouds_d"
            case .fewCloudsN:
                imageName = "weather_few_clouds_n"
            case .mist:
                imageName = "weather_mist"
            case .rain:
                imageName = "weather_rain"
            case .snow:
                imageName = "weather_snow"
            case .none:
                return UIImage()
            }
            return UIImage(named: imageName)!
        }
    }
    
    init(weather: TodayWeather) {
        self.weather = weather
        self.city = weather.name
        self.temp = WeatherViewModel.formatTemp(for: weather)
        self.weatherCondition = WeatherViewModel.formatWeatherCondition(for: weather)
        self.description = WeatherViewModel.formatDescription(for: weather)
        self.day = WeatherViewModel.formatDay()
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
    
    private static func formatDay() -> String {
        let date = Date()
        let formatter = DateFormatter()

        formatter.dateFormat = "dd.MM.yyyy"
        let today = formatter.string(from: date)
        
        switch getDayOfWeek(today: today, formatter: formatter) {
        case 1:
            return "Dimanche"
        case 2:
            return "Lundi"
        case 3:
            return "Mardi"
        case 4:
            return "Mercredi"
        case 5:
            return "Jeudi"
        case 6:
            return "Vendredi"
        case 7:
            return "Samedi"
        default:
            break
        }
        return ""
    }
    
    private static func getDayOfWeek(today: String, formatter: DateFormatter) -> Int? {

        if let todayDate = formatter.date(from: today) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            let myComponents = myCalendar.components(.weekday, from: todayDate)
            let weekDay = myComponents.weekday
            return weekDay
        } else {
            return nil
        }
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
