//
//  ForecastManager.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 05/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation

class ForecastManager {
    let list: [List]
    let lastForecast: [List]
    
    init(list: [List]) {
        self.list = list
        lastForecast = ForecastManager.getLastForecastOfTheDay(from: list)
    }
    
    static func getLastForecastOfTheDay(from list: [List]) -> [List] {
        var listLastForecast: [List] = []
        let dateForecast = getDateForecast(from: list)
        for date in dateForecast {
            if let index = list.map({ $0.dt_txt }).lastIndex(where: { $0.contains(date)}) {
                listLastForecast.append(list[index])
            }
        }
        return listLastForecast
    }
    
    private static func getDateForecast(from list: [List]) -> [String] {
        var dateForecast: [String] = []
        let currentDate = String(list.first.map({ $0.dt_txt })?.split(separator: " ").first ?? "")
        for i in 1...5 {
            let date = Calendar.current.date(byAdding: .day, value: i, to: Date().fromString(currentDate))
            dateForecast.append(date?.toString() ?? "")
        }
        return dateForecast
    }
}
