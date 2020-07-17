//
//  TranslationTests.swift
//  Le BaluchonTests
//
//  Created by Mahieu Bayon on 16/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

@testable import Le_Baluchon
import XCTest

class TranslationTests: XCTestCase, DecodableTestCase {
    
    // MARK: - Instance Properties
    var dictionary: NSDictionary!
    var sut: Translation!

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
    func test_decodable_sets_data() {
        XCTAssertEqual(sut.data["translations"]?.first.map({ $0 })?.translatedText,
                       "Hello")
    }

}
