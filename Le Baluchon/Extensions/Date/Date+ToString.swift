//
//  Date+ToString.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 05/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation

extension Date {
    // convert the date to a string
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter.string(from: self)
    }
}
