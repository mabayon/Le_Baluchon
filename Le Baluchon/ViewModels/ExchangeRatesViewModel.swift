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
    var devises: [Devise]
    
    // MARK: - Object Lifecycle
    init(exchangeRates: ExchangeRates) {
        self.exchangeRates = exchangeRates
        self.date = exchangeRates.date
        self.devises = ExchangeRatesViewModel.parseRates(from: exchangeRates)
      
        let devisesEUR = Devise(name: "EUR",
                               value: "1",
                               symbol: ExchangeRatesViewModel.checkSymbol(for: "EUR"),
                               image: ExchangeRatesViewModel.getImage(for: "EUR"))
        
        self.devises.append(devisesEUR)
    }
    
    private enum Symbol: String {
        case EUR = "€"
        case USD = "$"
    }

    private static func getImage(for country: String) -> UIImage {
        if let image = UIImage(named: country) {
            return image
        }
        return UIImage()
    }
    
    private static func parseRates(from exchangeRates: ExchangeRates) -> [Devise] {
        var devisess: [Devise] = []
        for (key, value) in exchangeRates.rates {
            devisess.append(Devise(name: key,
                                  value: String(value),
                                  symbol: checkSymbol(for: key),
                                  image: getImage(for: key)))
        }
        return devisess
    }
    
    private static func checkSymbol(for name: String) -> String {
        switch name {
        case "EUR":
            return Symbol.EUR.rawValue
        case "USD":
            return Symbol.USD.rawValue
        default:
            return ""
        }
    }
    
    func configure(fromDevise: Devise, fromDeviseLabel: UILabel, toDevise: Devise, toDeviseLabel: UILabel) {
        fromDeviseLabel.text = fromDevise.symbol
        toDeviseLabel.text = toDevise.value + toDevise.symbol
    }
}

extension ExchangeRatesViewModel: Equatable {
    static func == (lhs: ExchangeRatesViewModel, rhs: ExchangeRatesViewModel) -> Bool {
        return lhs.exchangeRates == rhs.exchangeRates
    }
}
