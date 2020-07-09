//
//  OpenWeather.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 02/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation

struct OpenWeather {
    static private let baseURL = "http://api.openweathermap.org/data/2.5/"
    static private let currentWeather = "weather"
    static private let forecast = "forecast"
    static private let accessKey = "?appid=\(APIKeys.OpenWeather)"
    static private var parameters = "&lang=fr&units=metric"
    static private var newYork = "&q=New%20York"
    static private var paris = "&q=Paris"
  
    static var latitude = "" {
        didSet {
            parameters = parameters + ("&lat=\(latitude)")
        }
    }
    
    static var longitude = "" {
        didSet {
            parameters = parameters + ("&lon=\(longitude)")
        }
    }
    
    static var urlCurrentWeather: String {
        return OpenWeather.baseURL + currentWeather + OpenWeather.accessKey + OpenWeather.parameters
    }
    
    static var urlForecast: String {
        return OpenWeather.baseURL + forecast + OpenWeather.accessKey + OpenWeather.parameters
    }
    
    static var urlParisWeather: String {
        return OpenWeather.baseURL + currentWeather + OpenWeather.accessKey + OpenWeather.parameters + paris
    }
    
    static var urlNewYorkWeather: String {
        return OpenWeather.baseURL + currentWeather + OpenWeather.accessKey + OpenWeather.parameters + newYork
    }

}
