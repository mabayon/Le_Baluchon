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
    let temps: [Temp]
    
    init(list: [List]) {
        self.list = list
        lastForecast = ForecastManager.getLastForecastOfTheDay(from: list)
        temps = ForecastManager.getMinMaxTemps(form: list)
    }
    
    private static func getLastForecastOfTheDay(from list: [List]) -> [List] {
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
    
    private static func getMinMaxTemps(form list: [List]) -> [Temp] {
        var temps: [Temp] = []
        let dateForecast = getDateForecast(from: list)
        for date in dateForecast {
            let listForDate = list.filter({ $0.dt_txt.contains(date) })
            temps.append(findMinMax(form: listForDate))
        }
        return temps
    }
    
    private static func findMinMax(form list: [List]) -> Temp {
        var minMaxTemp = Temp(min: 0, max: 0)
        let sortedTemp = list.map({ $0.main.temp }).sorted { $0 < $1 }
        if let min = sortedTemp.first, let max = sortedTemp.last {
            minMaxTemp = Temp(min: Int(min), max: Int(max))
        }
        return minMaxTemp
    }
}
