//
//  ForecastWeatherTests.swift
//  Le BaluchonTests
//
//  Created by Mahieu Bayon on 04/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

@testable import Le_Baluchon
import XCTest

class ForecastWeatherTests: XCTestCase, DecodableTestCase {
    
    var dictionary: NSDictionary!
    var sut: ForecastWeather!
    
    override func setUp() {
        super.setUp()
        try! givenSUTFromJSON()
    }
    
    override func tearDown() {
        dictionary = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Given
    func givenWeather() -> [Weather] {
        let listDict = dictionary["list"] as! [[String: Any]]
        var weather: [Weather] = []
        for dict in listDict {
            for (_, value) in dict.filter({ $0.key == "weather" }) {
                for dict in value as! [[String: Any]] {
                    let main = dict["main"] as! String
                    let description = dict["description"] as! String
                    let icon = dict["icon"] as! String
                    weather.append(Weather(main: main, description: description, icon: icon))
                }
            }
        }
        return weather
    }
    
    func givenMain() -> [Main] {
        let listDict = dictionary["list"] as! [[String: Any]]
        var main: [Main] = []
        for dict in listDict {
            for (_, mainDict) in dict.filter({ $0.key == "main" }) {
                for tempDict in (mainDict as! [String: Any]).filter({ $0.key == "temp"}) {
                    main.append(Main(temp: tempDict.value as! Double))
                }
            }
        }
        return main
    }
    
    func givenDt_txt() -> [String] {
        let listDict = dictionary["list"] as! [[String: Any]]
        var dt: [String] = []
        for dict in listDict {
            for dtDict in dict.filter({$0.key == "dt_txt"}) {
                dt.append(dtDict.value as! String)
            }
        }
        return dt
    }
        
    // MARK: - Type Tests
    func test_conformsTo_Decodable() {
        XCTAssertTrue((sut as Any) is Decodable) // cast silences a warning
    }
    
    func test_conformsTo_Equatable() {
        XCTAssertEqual(sut, sut) // requires Equatable conformance
    }
    
    // MARK: - Decodable - Test
    func test_decodable_setsList_weather() {
        let expectedWeather = givenWeather()

        var sutWeather: [Weather] = []
        _ = sut.list.map({ sutWeather.append(contentsOf: $0.weather)})
                
        XCTAssertEqual(sutWeather, expectedWeather)
    }
    
    func test_decodable_setsList_main() {
        let expectedMain = givenMain()
        
        var sutMain: [Main] = []
        _ = sut.list.map({ sutMain.append($0.main)})
     
        XCTAssertEqual(sutMain, expectedMain)
    }
    
    func test_decodable_setsList_dt_txt() {
        let expectedDt = givenDt_txt()
        var sutDt: [String] = []
        _ = sut.list.map({sutDt.append($0.dt_txt)})
        
        XCTAssertEqual(sutDt, expectedDt)        
    }
}
