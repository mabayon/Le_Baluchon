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
