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
    
    func givenLastForecastOfTheDay() {
        
    }
    // MARK: - Init - Tests
    func testInitList_setsList() {
        XCTAssertEqual(sut.list, list)
    }
    
    // MARK: - GetLastForecastOfTheDay - Tests
    func testGetLastForecastOfTheDay_createANewListWithOnlyTheLastForecastOfTheDay() {
        // Given
        let expected = ["2020-07-06 21:00:00",
                        "2020-07-07 21:00:00",
                        "2020-07-08 21:00:00",
                        "2020-07-09 21:00:00",
                        "2020-07-10 06:00:00"]

        let sutLastForecast = sut.lastForecast.map { $0.dt_txt }
        XCTAssertEqual(sutLastForecast, expected)
    }
}

// sutDt.filter({$0.contains("2020-07-10")}).last
// sut.list.map({ $0.dt_txt }).lastIndex(where: {$0.contains("2020-07-10")})
