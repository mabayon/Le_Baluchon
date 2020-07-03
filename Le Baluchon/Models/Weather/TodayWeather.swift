//
//  Weather.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 02/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation

struct TodayWeather: Decodable, Equatable {
    
    let weather: [Weather]
    let main: Main
    let name: String
}

struct Weather: Decodable, Equatable {
    let main: String
    let description: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case main
        case description
        case icon
    }
}

struct Main: Decodable, Equatable {
    let temp: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
    }
}
