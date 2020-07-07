//
//  ForecastManagerTests.swift
//  Le BaluchonTests
//
//  Created by Mahieu Bayon on 05/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

@testable import Le_Baluchon
import XCTest

class ForecastManagerTests: XCTestCase {

    var sut: ForecastManager!
    var list: [List]!
    
    override func setUp() {
        super.tearDown()
        try! givenListFromJson()
        sut = ForecastManager(list: list)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Given
    func givenListFromJson() throws {
        let decoder = JSONDecoder()
        let data = try Data.fromJSON(fileName: "ForecastWeather")
        let forecastWeather = try decoder.decode(ForecastWeather.self, from: data)
        list = forecastWeather.list
    }
    
    // MARK: - Init - Tests
    func testInitList_setsList() {
        XCTAssertEqual(sut.list, list)
    }
        
    // MARK: - LastForecast - Tests
    func testLastForecast_createANewListWithOnlyTheLastForecastOfTheDay() {
        // Given
        let expected = ["2020-07-06 21:00:00",
                        "2020-07-07 21:00:00",
                        "2020-07-08 21:00:00",
                        "2020-07-09 21:00:00",
                        "2020-07-10 06:00:00"]

        let sutLastForecast = sut.lastForecast.map { $0.dt_txt }
        XCTAssertEqual(sutLastForecast, expected)
    }
    
    // MARK: - Temps - Tests
    func testTemps_getTheMinMaxTemperatures() {
        let expected: [Temp] = [Temp(min: 13, max: 20),
                                Temp(min: 13, max: 24),
                                Temp(min: 16, max: 23),
                                Temp(min: 15, max: 28),
                                Temp(min: 17, max: 20)]
        
        XCTAssertEqual(sut.temps, expected)
    }
}
