//
//  WeatherTests.swift
//  Le BaluchonTests
//
//  Created by Mahieu Bayon on 02/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

@testable import Le_Baluchon
import XCTest

class WeatherTests: XCTestCase, DecodableTestCase {
    
    // MARK: - Instance Properties
    var dictionary: NSDictionary!
    var sut: TodayWeather!
    
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
    
    func test_conformsTo_Equatable() {
        XCTAssertEqual(sut, sut) // requires Equatable conformance
    }
    
    // MARK: - Decodable - Test
    
    func test_decodable_sets_weather() throws {
        
        let weather = dictionary["weather"] as! [[String: Any]]
        let main = weather.map { $0 }.first.map { $0 }?.filter{ $0.key == "main" }.first
        let description = weather.map { $0 }.first.map { $0 }?.filter{ $0.key == "description" }.first
        let icon = weather.map { $0 }.first.map { $0 }?.filter{ $0.key == "icon" }.first

        XCTAssertEqual(sut.weather.first?.main, main?.value as? String)
        XCTAssertEqual(sut.weather.first?.description, description?.value as? String)
        XCTAssertEqual(sut.weather.first?.icon, icon?.value as? String)

    }
    
    func test_decodable_sets_name() throws {
        try XCTAssertEqualToAny(sut.name, dictionary["name"])
    }
    
    func test_decodable_sets_main() throws {
        let expected = Main(temp: 15.67)
        try XCTAssertEqualToAny(sut.main, expected)
    }
}
