//
//  ExchangeRatesTests.swift
//  Le BaluchonTests
//
//  Created by Mahieu Bayon on 08/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

@testable import Le_Baluchon
import XCTest

class ExchangeRatesTests: XCTestCase, DecodableTestCase {

    // MARK: - Instance Properties
    var dictionary: NSDictionary!
    var sut: ExchangeRates!
    
    // MARK: - Test Lifecyle
    override func setUp() {
        super.setUp()
        try! givenSUTFromJSON()

    }

    override func tearDown() {
        dictionary = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Type Tests
    func test_conformsTo_Decodable() {
      XCTAssertTrue((sut as Any) is Decodable) // cast silences a warning
    }
    
    // MARK: - Decodable - Test
    func test_decodable_sets_date() throws {
        try XCTAssertEqualToAny(sut.date, dictionary["date"])
    }
    
    func test_decodable_sets_base() throws {
        try XCTAssertEqualToAny(sut.base, dictionary["base"])
    }
    
    func test_decodable_sets_rates() throws {
        try XCTAssertEqualToAny(sut.rates, dictionary["rates"])
    }
}
