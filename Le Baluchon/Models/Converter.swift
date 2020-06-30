//
//  Converter.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 29/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation

class Converter {
    
    let rates: [String: Double]
    var result: Double?
    
    init(rates: [String: Double]) {
        self.rates = rates
    }
    
    func calculRates(for amount: Double, fromDevise: String, toDevise: String) {
        
        if fromDevise == "EUR" {
            guard let rates = rates[toDevise] else {
                result = nil
                return
            }
            
            result = Double(round(10000 * (amount * rates)) / 10000)
        } else {
            guard let rates = rates[fromDevise] else {
                result = nil
                return
            }

            let ratesEUR = (100.0 / rates) / 100.0
            result = Double(round(10000 * (amount * ratesEUR)) / 10000)
        }
    }
}
