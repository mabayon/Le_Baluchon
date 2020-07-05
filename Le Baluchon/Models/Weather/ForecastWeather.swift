//
//  ForecastWeather.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 04/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation

struct ForecastWeather: Decodable, Equatable {
    let list: [List]
}

struct List: Decodable, Equatable {
    
    let weather: [Weather]
    let main: Main
    let dt_txt: String
}
