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
    var currencies: [Currency] 
    
    // MARK: - Object Lifecycle
    init(exchangeRates: ExchangeRates) {
        self.exchangeRates = exchangeRates
        self.date = exchangeRates.date
        self.currencies = ExchangeRatesViewModel.parseRates(from: exchangeRates)
      
        let currenciesEUR = Currency(name: "EUR",
                               value: "1",
                               symbol: ExchangeRatesViewModel.selectSymbol(for: "EUR"))
        
        self.currencies.append(currenciesEUR)
        self.currencies = ExchangeRatesViewModel.sortCurrency(currencies)
    }
    
    private enum Symbol: String {
        case EUR = "€"
        case USD_CAD = "$"
        case GBP = "£"
        case CNY_JPY = "¥"
    }
    
    private static func parseRates(from exchangeRates: ExchangeRates) -> [Currency] {
        var currencies: [Currency] = []
        for (key, value) in exchangeRates.rates {
            currencies.append(Currency(name: key,
                                  value: String(value),
                                  symbol: selectSymbol(for: key)))
        }
        return currencies
    }
        
    private static func selectSymbol(for name: String) -> String {
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
    
    private static func sortCurrency(_ currencies: [Currency]) -> [Currency] {
        let currenciesOrder = ["USD", "GBP", "CNY", "JPY", "CAD", "EUR"]
        let currenciesContained = currenciesOrder.filter { currencies.map({ $0.name }).contains($0) }
        var sortedCurrency = currencies
        
        for i in 0...currenciesContained.count - 1 {
            if let index = sortedCurrency.map ({ $0.name })
                .firstIndex(of: currenciesContained[i]) {
                sortedCurrency.rearrange(from: index, to: i)
            }
        }
        return sortedCurrency
    }
    
    private func getSymbol(for country: String) -> String {
        return currencies.filter ({ $0.name == country }).map({ $0.symbol}).first ?? ""
    }
    
    private func getValue(for currency: String) -> String {
        guard let value = currencies.filter({ $0.name == currency }).first?.value else {
            return ""
        }
        return value
    }
    
    func configure(fromCurrency: String,
                   toCurrency: String,
                   completion: @escaping (String, String) -> ()) {
        
        let fromCurrencySymbol = getSymbol(for: fromCurrency)
        let toCurrency = getValue(for: toCurrency) + getSymbol(for: toCurrency)
        
        completion(fromCurrencySymbol, toCurrency)
    }
    
    func configure2(fromCurrency: Currency,
                   fromCurrencyLabel: UILabel,
                   toCurrency: Currency,
                   toCurrencyLabel: UILabel) {
        fromCurrencyLabel.text = fromCurrency.symbol
        toCurrencyLabel.text = toCurrency.value + toCurrency.symbol
    }
}

extension ExchangeRatesViewModel: Equatable {
    static func == (lhs: ExchangeRatesViewModel, rhs: ExchangeRatesViewModel) -> Bool {
        return lhs.exchangeRates == rhs.exchangeRates
    }
}
