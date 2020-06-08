//
//  ExchangeRates.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 08/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation

struct ExchangeRates: Decodable {
    
    // MARK: - Instance Properties
    let timestamp: Date
    let base: String
    let rates: [String: Double]
}
