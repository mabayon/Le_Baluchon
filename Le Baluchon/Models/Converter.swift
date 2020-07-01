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
    
    var state: State = .fromEUR {
        didSet {
          stateChangedCallback?(self)
        }
    }
    
    var stateChangedCallback: ((Converter) -> ())?

    enum State {
        case fromEUR, toEUR
    }
    
    init(rates: [String: Double]) {
        self.rates = rates
    }
    
    func calculRates(for amount: Double, fromDevise: String, toDevise: String) {
        
        switch state {
        case .fromEUR:
            guard let rates = rates[toDevise] else {
                result = nil
                return
            }
            
            result = Double(round(10000 * (amount * rates)) / 10000)
        case .toEUR:
            guard let rates = rates[fromDevise] else {
                result = nil
                return
            }

            let ratesEUR = (100.0 / rates) / 100.0
            result = Double(round(10000 * (amount * ratesEUR)) / 10000)
        }
    }
}
