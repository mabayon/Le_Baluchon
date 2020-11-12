//
//  Date+FromString.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 05/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation

extension Date {
    // Convert a string to a date
    func fromString(_ dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter.date(from: dateString) ?? Date()
    }
}
