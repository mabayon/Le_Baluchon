//
//  ExchangeRatesViewModelTests.swift
//  Le BaluchonTests
//
//  Created by Mahieu Bayon on 09/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

@testable import Le_Baluchon
import XCTest

class ExchangeRatesViewModelTests: XCTestCase {
    
    // MARK: - Instance Properties
    var sut: ExchangeRatesViewModel!
    var exchangeRates: ExchangeRates!
    
    // MARK: - Test Lifecycle
    override func setUp() {
        super.setUp()
        whenSUTSetFromExchangeRates()
    }
    
    override func tearDown() {
        exchangeRates = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - When
    func whenSUTSetFromExchangeRates(date: String = "2020-06-09",
                                     base: String = "EUR",
                                     rates: [String: Double] = ["USD": 1.12972]) {
        
        exchangeRates = ExchangeRates(base: base, date: date, rates: rates)
        sut = ExchangeRatesViewModel(exchangeRates: exchangeRates)
    }
        
    // MARK: - Init - Tests
    func test_initExchangeRates_setsExchangeRates() {
        XCTAssertEqual(sut.exchangeRates, exchangeRates)
    }
    
    func test_initExchangeRates_setsDate() {
        XCTAssertEqual(sut.date, exchangeRates.date)
    }
    
    func test_initExchangeRates_givenRates_setsCurrency() {
        // Given
        whenSUTSetFromExchangeRates(rates: ["USD": 1.12972,
                                            "GBP": 1.12972,
                                            "CNY": 1.12972,
                                            "JPY": 1.12972,
                                            "CAD": 1.12972])
        
        // Then
        let expectedCurrency = [Currency(name: "USD", value: "1.12972", symbol: "$"),
                                Currency(name: "GBP", value: "1.12972", symbol: "£"),
                                Currency(name: "CNY", value: "1.12972", symbol: "¥"),
                                Currency(name: "JPY", value: "1.12972", symbol: "¥"),
                                Currency(name: "CAD", value: "1.12972", symbol: "$"),
                                Currency(name: "EUR", value: "1", symbol: "€")]
        
        XCTAssertEqual(sut.currencies, expectedCurrency)
    }
    
    func test_initExchangeRates_givenUnknownCurrency_setCurrency() {
        // Given
        whenSUTSetFromExchangeRates(rates: ["AUD": 1.12972])
        
        let expectedCurrency = [Currency(name: "EUR", value: "1", symbol: "€"),
                                Currency(name: "AUD", value: "1.12972", symbol: ""),]
        // Then
        XCTAssertEqual(sut.currencies, expectedCurrency)
    }
    
    func testConfigure_givenUnknownCurrency_valueWillBeEmpty() {
        // Given
        sut.configure(fromCurrency: "EUR", toCurrency: "UNK") { (fromCurrency, toCurrency) in
            XCTAssertEqual(toCurrency, "")
        }
    }
}
