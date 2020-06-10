//
//  ExchangeRatesViewModel.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 09/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation
import UIKit

class ExchangeRatesViewModel {
    
    // MARK: - Instance Properties
    let exchangeRates: ExchangeRates
    
    let date: String
    let deviseBase: Devise
    let devisesRates: [Devise]
    
    // MARK: - Object Lifecycle
    init(exchangeRates: ExchangeRates) {
        self.exchangeRates = exchangeRates
        self.date = exchangeRates.date
        self.deviseBase = Devise(name: exchangeRates.base,
                                 value: 1,
                                 image: ExchangeRatesViewModel.getImage(for: exchangeRates.base)
        )
        self.devisesRates = ExchangeRatesViewModel.parseRates(from: exchangeRates)
    }
    
    private static func getImage(for country: String) -> UIImage {
        if let image = UIImage(named: country) {
            return image
        }
        return UIImage()
    }
    
    private static func parseRates(from exchangeRates: ExchangeRates) -> [Devise] {
        var devises: [Devise] = []
        for (key, value) in exchangeRates.rates {
            devises.append(Devise(name: key, value: value, image: getImage(for: key)))
        }
        return devises
    }
}
