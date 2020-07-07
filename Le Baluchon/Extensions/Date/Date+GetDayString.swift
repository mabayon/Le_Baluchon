//
//  Date+GetDayString.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 03/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation

extension Date {
    
    static func getDayString(for date: Date = Date()) -> String {
        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy.MM.dd"
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
}
