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
                               symbol: ExchangeRatesViewModel.checkSymbol(for: "EUR"))
        
        self.devises.append(devisesEUR)
        self.devises = ExchangeRatesViewModel.sortDevise(devises)
    }
    
    private enum Symbol: String {
        case EUR = "€"
        case USD_CAD = "$"
        case GBP = "£"
        case CNY_JPY = "¥"
    }
    
    private static func parseRates(from exchangeRates: ExchangeRates) -> [Devise] {
        var devises: [Devise] = []
        for (key, value) in exchangeRates.rates {
            devises.append(Devise(name: key,
                                  value: String(value),
                                  symbol: checkSymbol(for: key)))
        }
        return devises
    }
    
    private static func checkSymbol(for name: String) -> String {
        switch name {
        case "EUR":
            return Symbol.EUR.rawValue
        case "USD", "CAD":
            return Symbol.USD_CAD.rawValue
        case "GBP":
            return Symbol.GBP.rawValue
        case "CNY", "JPY":
            return Symbol.CNY_JPY.rawValue
        default:
            return ""
        }
    }
    
    private static func sortDevise(_ devises: [Devise]) -> [Devise] {
        let devisesOrder = ["USD", "GBP", "CNY", "JPY", "CAD", "EUR"]
        let devisesContained = devisesOrder.filter { devises.map({ $0.name }).contains($0) }
        var sortedDevises = devises
        
        for i in 0...devisesContained.count - 1 {
            if let index = sortedDevises.map ({ $0.name })
                .firstIndex(of: devisesContained[i]) {
                sortedDevises.rearrange(from: index, to: i)
            }
        }
        return sortedDevises
    }
    
    func getSymbol(for country: String) -> String? {
        return devises.filter ({ $0.name == country }).map({ $0.symbol}).first
    }
    
    func configure(fromDevise: Devise,
                   fromDeviseLabel: UILabel,
                   toDevise: Devise,
                   toDeviseLabel: UILabel) {
        fromDeviseLabel.text = fromDevise.symbol
        toDeviseLabel.text = toDevise.value + toDevise.symbol
    }
}

extension ExchangeRatesViewModel: Equatable {
    static func == (lhs: ExchangeRatesViewModel, rhs: ExchangeRatesViewModel) -> Bool {
        return lhs.exchangeRates == rhs.exchangeRates
    }
}
