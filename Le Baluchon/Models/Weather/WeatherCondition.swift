//
//  WeatherCondition.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 04/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation
import UIKit

enum WeatherCondition {
    case clearSky, clearSkyN, thunderstorm, thunderstormN,
    clouds, cloudsN, fewClouds, fewCloudsN, mist, mistN, rain, rainN, snow, snowN, none
    
    var image: UIImage {
        let imageName: String
        switch self {
        case .clearSky:
            imageName = "weather_clear_sky_d"
        case .clearSkyN:
            imageName = "weather_clear_sky_n"
        case .thunderstorm, .thunderstormN:
            imageName = "weather_thunderstorm"
        case .clouds, .cloudsN:
            imageName = "weather_clouds"
        case .fewClouds:
            imageName = "weather_few_clouds_d"
        case .fewCloudsN:
            imageName = "weather_few_clouds_n"
        case .mist, .mistN:
            imageName = "weather_mist"
        case .rain, .rainN:
            imageName = "weather_rain"
        case .snow, .snowN:
            imageName = "weather_snow"
        case .none:
            return UIImage()
        }
        return UIImage(named: imageName)!
    }
    
    var imageWhite: UIImage {
        let imageName: String
        switch self {
        case .clearSky:
            imageName = "weather_clear_sky_d_white"
        case .clearSkyN:
            imageName = "weather_clear_sky_n_white"
        case .thunderstorm, .thunderstormN:
            imageName = "weather_thunderstorm_white"
        case .clouds, .cloudsN:
            imageName = "weather_clouds_white"
        case .fewClouds:
            imageName = "weather_few_clouds_d_white"
        case .fewCloudsN:
            imageName = "weather_few_clouds_n_white"
        case .mist, .mistN:
            imageName = "weather_mist_white"
        case .rain, .rainN:
            imageName = "weather_rain_white"
        case .snow, .snowN:
            imageName = "weather_snow_white"
        case .none:
            return UIImage()
        }
        return UIImage(named: imageName)!
    }

}
