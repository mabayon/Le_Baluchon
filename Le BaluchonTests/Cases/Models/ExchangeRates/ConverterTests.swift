//
//  ConverterTests.swift
//  Le BaluchonTests
//
//  Created by Mahieu Bayon on 29/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

@testable import Le_Baluchon
import XCTest

class ConverterTests: XCTestCase {

    // MARK: - Instance Properties
    var sut: Converter!
    var rates: [String: Double] = [:]
    
    // MARK: - Test Lifecycle
    override func setUp() {
        super.setUp()
        rates = ["USD": 1.12972]
        sut = Converter(rates: rates)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
        
    // MARK: - Init - Tests
    func testInitRates_setsRates() {
        // Then
        XCTAssertEqual(sut.rates, rates)
    }
    
    // MARK: - CalculRates - Tests
    func testCalculRates_formEUR_convertEURToUSD() {
        // Given
        let ratesUSD = 1.12972
        let amountToConvert = 10.0
        
        let result = amountToConvert * ratesUSD
    
        // When
        sut.calculRates(for: 10, fromCurrency: "EUR", toCurrency: "USD")
        
        // Then
        XCTAssertEqual(sut.result, result)
    }
        
    func testCalculRates_toEUR_convertUSDtoEUR() {
        let ratesUSD = 1.12972
        let amountToConvert = 10.0
        let ratesEUR = (100.0 / ratesUSD) / 100.0
        let result = Double(round(10000 * (amountToConvert * ratesEUR)) / 10000)
        
        // When
        sut.state = .toEUR
        sut.calculRates(for: 10, fromCurrency: "USD", toCurrency: "EUR")
        
        // Then
        XCTAssertEqual(sut.result, result)
    }
    
    func testCalculRates_toCurrencyInvalid_resultNil() {
        // Given
        let invalidCurrency = "GGG"
        
        // When
        sut.calculRates(for: 10, fromCurrency: "EUR", toCurrency: invalidCurrency)
        
        // Then
        XCTAssertNil(sut.result)
    }

    func testCalculRates_fromCurrencyInvalid_resultNil() {
        // Given
        let invalidCurrency = "GGG"
        
        // When
        sut.state = .toEUR
        sut.calculRates(for: 10, fromCurrency: invalidCurrency, toCurrency: "EUR")
        
        // Then
        XCTAssertNil(sut.result)
    }

}
