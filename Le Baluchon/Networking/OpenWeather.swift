//
//  OpenWeather.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 02/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation

struct OpenWeather {
    static private let baseURL = "http://api.openweathermap.org/data/2.5/weather"
    static private let accessKey = "?appid=\(APIKeys.OpenWeather)"
    static private var parameters = "&lang=fr&units=metric"
    
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
    
    static var url: String { return OpenWeather.baseURL + OpenWeather.accessKey + OpenWeather.parameters }

    
}
