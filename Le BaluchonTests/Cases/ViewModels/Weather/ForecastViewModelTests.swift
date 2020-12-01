//
//  ForecastViewModelTests.swift
//  Le BaluchonTests
//
//  Created by Mahieu Bayon on 05/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

@testable import Le_Baluchon
import XCTest

class ForecastViewModelTests: XCTestCase {
    
    var sut: ForecastViewModel!
    var forecast: List!
    var temp: Temp!
    var cell: ForecastTableViewCell!
    
    override func setUp() {
        super.setUp()
        try! givenListFromForecastManager()
        sut = ForecastViewModel(forecast: forecast, temps: temp)
    }
    
    override func tearDown() {
        forecast = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Helper methods
    func createWeather(icon: String = "09d") -> [Weather] {
        return [Weather(main: "", description: "", icon: icon)]
    }
    
    // MARK: - Given
    func givenListFromForecastManager() throws {
        let decoder = JSONDecoder()
        let data = try Data.fromJSON(fileName: "ForecastWeather")
        let forecastWeather = try decoder.decode(ForecastWeather.self, from: data)
        let forecastManager = ForecastManager(list: forecastWeather.list)
        forecast = forecastManager.lastForecast.first
        temp = forecastManager.temps.first
    }
    
    func givenForecastTableViewCell() {
        let viewController = WeatherViewController.instanceFromStoryboard()
        viewController.loadViewIfNeeded()
        
        let collectionView = viewController.collectionView!
        let cellCV = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier,
                                                        for: IndexPath(item: 0, section: 0)) as? WeatherCollectionViewCell
        let tableView = cellCV?.forecastTableView
        cell = tableView?.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier) as? ForecastTableViewCell
    }
    
    // MARK: - When
    func whenConfigureForecastTableViewCell() {
        givenForecastTableViewCell()
        sut.configure(cell)
    }
    
    
    // MARK: - Init - Tests
    func test_initForecast_setsForecast() {
        XCTAssertEqual(sut.forecast, forecast)
    }
    
    func test_initForecast_setsDay() {
        let expected = "Lundi"
        XCTAssertEqual(sut.day, expected)
    }
    
    func test_initForecast_setsTempMax() {
        let expected = "20"
        XCTAssertEqual(sut.tempMax, expected)
    }
    
    func test_initForecast_setsTempMin() {
        let expected = "13"
        XCTAssertEqual(sut.tempMin, expected)
    }
    
    func test_initForecast_setsweatherCondition() {
        let expected: WeatherCondition = .clouds
        XCTAssertEqual(sut.weatherCondition, expected)
    }
    
    func test_initForecast_givenCoditions_rain_WeatherConditionWillBeRain() {
        // Given
        forecast = List(weather: createWeather(), main: Main(temp: 20), dt_txt: "")
        sut = ForecastViewModel(forecast: forecast, temps: temp)
        
        let expected = WeatherCondition.rain
        
        XCTAssertEqual(sut.weatherCondition, expected)
    }
    
    func test_initForecast_givenCoditions_clearSky_WeatherConditionWillBeClearSky() {
        // Given
        forecast = List(weather: createWeather(icon: "01d"), main: Main(temp: 20), dt_txt: "")
        sut = ForecastViewModel(forecast: forecast, temps: temp)
        
        let expected = WeatherCondition.clearSky
        
        XCTAssertEqual(sut.weatherCondition, expected)
    }
    
    
    func test_initForecast_givenCoditions_fewClouds_WeatherConditionWillBeFewCloudsD() {
        // Given
        forecast = List(weather: createWeather(icon: "02d"), main: Main(temp: 20), dt_txt: "")
        sut = ForecastViewModel(forecast: forecast, temps: temp)
        
        let expected = WeatherCondition.fewClouds
        
        XCTAssertEqual(sut.weatherCondition, expected)
    }
    
    func test_initForecast_givenCoditions_clouds_WeatherConditionWillBeClouds() {
        // Given
        forecast = List(weather: createWeather(icon: "03d"), main: Main(temp: 20), dt_txt: "")
        sut = ForecastViewModel(forecast: forecast, temps: temp)
        
        let expected = WeatherCondition.clouds
        
        XCTAssertEqual(sut.weatherCondition, expected)
    }
    
    func test_initForecast_givenCoditions_thunderstorm_WeatherConditionWillBeThunderstorm() {
        // Given
        forecast = List(weather: createWeather(icon: "11d"), main: Main(temp: 20), dt_txt: "")
        sut = ForecastViewModel(forecast: forecast, temps: temp)
        
        let expected = WeatherCondition.thunderstorm
        
        XCTAssertEqual(sut.weatherCondition, expected)
    }
    
    func test_initForecast_givenCoditions_snow_WeatherConditionWillBeClearSnow() {
        // Given
        forecast = List(weather: createWeather(icon: "13d"), main: Main(temp: 20), dt_txt: "")
        sut = ForecastViewModel(forecast: forecast, temps: temp)
        
        let expected = WeatherCondition.snow
        
        XCTAssertEqual(sut.weatherCondition, expected)
    }
    
    func test_initForecast_givenCoditions_mist_WeatherConditionWillBeMist() {
        // Given
        forecast = List(weather: createWeather(icon: "50d"), main: Main(temp: 20), dt_txt: "")
        sut = ForecastViewModel(forecast: forecast, temps: temp)
        
        let expected = WeatherCondition.mist
        
        XCTAssertEqual(sut.weatherCondition, expected)
    }
    
    
    
    func test_initForecast_givenUnknownCondition_weatherConditionWillBeNone() {
        // Given
        forecast = List(weather: createWeather(icon: "unknown"), main: Main(temp: 20), dt_txt: "")
        sut = ForecastViewModel(forecast: forecast, temps: temp)
        
        let expected = WeatherCondition.none
        
        XCTAssertEqual(sut.weatherCondition, expected)
    }
    
    // MARK: - Cell Configuration - Tests
    func test_configureCell_setsDay() {
        // When
        whenConfigureForecastTableViewCell()
        
        // Then
        XCTAssertEqual(cell.dayLabel.text, sut.day)
    }
    
    func test_configureCell_setsTempMaxLabel() {
        // When
        whenConfigureForecastTableViewCell()
        
        // Then
        XCTAssertEqual(cell.tempMaxLabel.text, sut.tempMax)
    }
    
    func test_configureCell_setsTempMinLabel() {
        // When
        whenConfigureForecastTableViewCell()
        
        // Then
        XCTAssertEqual(cell.tempMinLabel.text, sut.tempMin)
    }
    
}
