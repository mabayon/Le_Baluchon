//
//  WeatherViewModelTests.swift
//  Le BaluchonTests
//
//  Created by Mahieu Bayon on 03/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

@testable import Le_Baluchon
import XCTest

class WeatherViewModelTests: XCTestCase {

    var sut: WeatherViewModel!
    var cell: WeatherCollectionViewCell!
    var todayWeather: TodayWeather! {
        didSet {
            if todayWeather != nil {
                sut = WeatherViewModel(weather: todayWeather)
            }
        }
    }
    
    override func setUp() {
        super.setUp()
        todayWeather = createTodayWeather()
    }
    
    override func tearDown() {
        todayWeather = nil
        sut = nil
        super.tearDown()
    }
    // MARK: Helper Methods
    
    func createTodayWeather(weather: [Weather] = [Weather(main: "Clouds",
                                                          description: "partiellement nuageux",
                                                          icon: "03d")]) -> TodayWeather {
        let main = Main(temp: 22.66)
        let name = "Paris"
        return TodayWeather(weather: weather, main: main, name: name)
    }
    
    // MARK: Given
    func givenWeatherCollectionViewCell() {
        let viewController = WeatherViewController.instanceFromStoryboard()
        viewController.loadViewIfNeeded()
        
        let collectionView = viewController.collectionView!
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier,
                                                        for: IndexPath(item: 0, section: 0)) as? WeatherCollectionViewCell
    }
    
    // MARK: - When
    func whenConfigureForecastTableViewCell() {
        givenWeatherCollectionViewCell()
        sut.configure(cell)
    }

    // MARK: - Init - Tests
    func test_initWeather_setsTodayWeather() {
        XCTAssertEqual(sut.weather, todayWeather)
    }
    
    func test_initWeather_setsCityName() {
        XCTAssertEqual(sut.city, todayWeather.name)
    }
    
    func test_initWeather_givenTempDouble_setsAndFormatTempString() {
        // Then
        let expected = "23°"
        XCTAssertEqual(sut.temp, expected)
    }
    
    func test_initWeather_setsDescription() {
        XCTAssertEqual(sut.description, todayWeather.weather.first?.description)
    }
    
    func test_initWeather_setsDay() {
        XCTAssertEqual(sut.day, Date.getDayString())
    }
    
    func test_initWeather_givenDaylightAndCoditionsClearSky_WeatherConditionWillBeClearSkyD() {
        // Given
        todayWeather =  createTodayWeather(weather: [Weather(main: "Clear",
                                                             description: "clear sky",
                                                             icon: "01d")])
        
        XCTAssertEqual(sut.weatherCondition, WeatherCondition.clearSky)
        XCTAssertEqual(sut.weatherCondition.image, UIImage(named: "weather_clear_sky_d"))
    }
    
    func test_initWeather_givenNightAndCoditionsClearSky_WeatherConditionWillBeClearSkyN() {
        // Given
        todayWeather =  createTodayWeather(weather: [Weather(main: "Clear",
                                                             description: "clear sky",
                                                             icon: "01n")])
        XCTAssertEqual(sut.weatherCondition, WeatherCondition.clearSkyN)
        XCTAssertEqual(sut.weatherCondition.image, UIImage(named: "weather_clear_sky_n"))
    }

    func test_initWeather_givenDaylightAndCoditionsFewClouds_WeatherConditionWillBeFewCloudsD() {
        // Given
        todayWeather =  createTodayWeather(weather: [Weather(main: "Clouds",
                                                             description: "few clouds",
                                                             icon: "02d")])
        XCTAssertEqual(sut.weatherCondition, WeatherCondition.fewClouds)
        XCTAssertEqual(sut.weatherCondition.image, UIImage(named: "weather_few_clouds_d"))
    }

    func test_initWeather_givenNightAndCoditionsFewClouds_WeatherConditionWillBeFewCloudsN() {
        // Given
        todayWeather =  createTodayWeather(weather: [Weather(main: "Clouds",
                                                             description: "few clouds",
                                                             icon: "02n")])
        XCTAssertEqual(sut.weatherCondition, WeatherCondition.fewCloudsN)
        XCTAssertEqual(sut.weatherCondition.image, UIImage(named: "weather_few_clouds_n"))
    }

    func test_initWeather_givenDaylightAndConditionsScatteredClouds_weatherConditionsWillBeClouds() {
        // Given
        todayWeather =  createTodayWeather(weather: [Weather(main: "Clouds",
                                                             description: "scattered clouds",
                                                             icon: "03d")])
        XCTAssertEqual(sut.weatherCondition, WeatherCondition.clouds)
        XCTAssertEqual(sut.weatherCondition.image, UIImage(named: "weather_clouds"))
    }
    
    func test_initWeather_givenNightAndCoditionsScatteredClouds_WeatherConditionWillBeClouds() {
        // Given
        todayWeather =  createTodayWeather(weather: [Weather(main: "Clouds",
                                                             description: "scattered clouds",
                                                             icon: "03n")])
        XCTAssertEqual(sut.weatherCondition, WeatherCondition.cloudsN)
        XCTAssertEqual(sut.weatherCondition.image, UIImage(named: "weather_clouds"))
    }
    
    func test_initWeather_givenDaylightAndConditionsBrokenClouds_weatherConditionsWillBeClouds() {
        // Given
        todayWeather =  createTodayWeather(weather: [Weather(main: "Clouds",
                                                             description: "broken clouds",
                                                             icon: "04d")])
        XCTAssertEqual(sut.weatherCondition, WeatherCondition.clouds)
        XCTAssertEqual(sut.weatherCondition.image, UIImage(named: "weather_clouds"))
    }
    
    func test_initWeather_givenNightAndConditionsBrokenClouds_weatherConditionsWillBeClouds() {
        // Given
        todayWeather =  createTodayWeather(weather: [Weather(main: "Clouds",
                                                             description: "broken clouds",
                                                             icon: "04n")])
        XCTAssertEqual(sut.weatherCondition, WeatherCondition.cloudsN)
        XCTAssertEqual(sut.weatherCondition.image, UIImage(named: "weather_clouds"))
    }

    func test_initWeather_givenDaylightAndConditionsShowerRain_weatherConditionsWillBeRain() {
        // Given
        todayWeather =  createTodayWeather(weather: [Weather(main: "Rain",
                                                             description: "shower rain",
                                                             icon: "09d")])
        XCTAssertEqual(sut.weatherCondition, WeatherCondition.rain)
        XCTAssertEqual(sut.weatherCondition.image, UIImage(named: "weather_rain"))
    }
    
    func test_initWeather_givenNightAndConditionsShowerRain_weatherConditionsWillBeRain() {
        // Given
        todayWeather =  createTodayWeather(weather: [Weather(main: "Rain",
                                                             description: "shower rain",
                                                             icon: "09n")])
        XCTAssertEqual(sut.weatherCondition, WeatherCondition.rainN)
        XCTAssertEqual(sut.weatherCondition.image, UIImage(named: "weather_rain"))

    }

    func test_initWeather_givenDaylightAndConditionsRain_weatherConditionsWillBeRain() {
        // Given
        todayWeather =  createTodayWeather(weather: [Weather(main: "Rain",
                                                             description: "rain",
                                                             icon: "10d")])
        XCTAssertEqual(sut.weatherCondition, WeatherCondition.rain)
        XCTAssertEqual(sut.weatherCondition.image, UIImage(named: "weather_rain"))
    }
    
    func test_initWeather_givenNightAndConditionsRain_weatherConditionsWillBeRain() {
        // Given
        todayWeather =  createTodayWeather(weather: [Weather(main: "Rain",
                                                             description: "rain",
                                                             icon: "10n")])
        XCTAssertEqual(sut.weatherCondition, WeatherCondition.rainN)
        XCTAssertEqual(sut.weatherCondition.image, UIImage(named: "weather_rain"))
    }

    func test_initWeather_givenDaylightAndConditionsThunderstorm_weatherConditionsWillBeThunderstorm() {
        // Given
        todayWeather =  createTodayWeather(weather: [Weather(main: "Thunderstorm",
                                                             description: "thunderstorm",
                                                             icon: "11d")])
        XCTAssertEqual(sut.weatherCondition, WeatherCondition.thunderstorm)
        XCTAssertEqual(sut.weatherCondition.image, UIImage(named: "weather_thunderstorm"))
    }
    
    func test_initWeather_givenNightAndConditionsThunderstorm_weatherConditionsWillBeThunderstorm() {
        // Given
        todayWeather =  createTodayWeather(weather: [Weather(main: "Thunderstorm",
                                                             description: "thunderstorm",
                                                             icon: "11n")])
        XCTAssertEqual(sut.weatherCondition, WeatherCondition.thunderstormN)
        XCTAssertEqual(sut.weatherCondition.image, UIImage(named: "weather_thunderstorm"))
    }

    func test_initWeather_givenDaylightAndConditionsSnow_weatherConditionsWillBeSnow() {
        // Given
        todayWeather =  createTodayWeather(weather: [Weather(main: "Snow",
                                                             description: "snow",
                                                             icon: "13d")])
        XCTAssertEqual(sut.weatherCondition, WeatherCondition.snow)
        XCTAssertEqual(sut.weatherCondition.image, UIImage(named: "weather_snow"))
    }
    
    func test_initWeather_givenNightAndConditionsSnow_weatherConditionsWillBeSnow() {
        // Given
        todayWeather =  createTodayWeather(weather: [Weather(main: "Snow",
                                                             description: "snow",
                                                             icon: "13n")])
        XCTAssertEqual(sut.weatherCondition, WeatherCondition.snowN)
        XCTAssertEqual(sut.weatherCondition.image, UIImage(named: "weather_snow"))
    }

    func test_initWeather_givenDaylightAndConditionsMist_weatherConditionsWillBeMist() {
        // Given
        todayWeather =  createTodayWeather(weather: [Weather(main: "Mist",
                                                             description: "mist",
                                                             icon: "50d")])
        XCTAssertEqual(sut.weatherCondition, WeatherCondition.mist)
        XCTAssertEqual(sut.weatherCondition.image, UIImage(named: "weather_mist"))
    }
    
    func test_initWeather_givenNightAndConditionsMist_weatherConditionsWillBeMist() {
        // Given
        todayWeather =  createTodayWeather(weather: [Weather(main: "Mist",
                                                             description: "mist",
                                                             icon: "50n")])
        XCTAssertEqual(sut.weatherCondition, WeatherCondition.mistN)
        XCTAssertEqual(sut.weatherCondition.image, UIImage(named: "weather_mist"))
    }

    func test_initWeather_givenUnknownIcon_weatherConditionsWillBeNone() {
        // Given
        todayWeather =  createTodayWeather(weather: [Weather(main: "Unknown",
                                                             description: "Unknown",
                                                             icon: "50")])
        XCTAssertEqual(sut.weatherCondition, WeatherCondition.none)
        XCTAssertEqual(sut.weatherCondition.image, UIImage())
    }
    
    // MARK: - Configure - Tests
//    func test_configure_setsImageViewImage() {
//        // When
//        whenConfigureTodayWeatherView()
//        
//        var expectedImage = sut.weatherCondition.image
//        expectedImage = expectedImage.aspectFitImage(inRect: todayWeatherView?.imageView.frame ?? CGRect.zero) ?? expectedImage
//        XCTAssertEqual(todayWeatherView.imageView.image?.size, expectedImage.size)
//    }
        
    func test_configure_setsCityLabel() {
        // When
        whenConfigureForecastTableViewCell()
        XCTAssertEqual(cell.cityLabel.text, sut.city)
    }
    
    func test_configure_setsTempLabel() {
        // When
        whenConfigureForecastTableViewCell()
        XCTAssertEqual(cell.tempLabel.text, sut.temp)
    }
    
    func test_configure_setsDescriptionLabel() {
        // When
        whenConfigureForecastTableViewCell()
        XCTAssertEqual(cell.weatherDescriptionLabel.text, sut.description)
    }

    func test_configure_setsDayLabel() {
        // When
        whenConfigureForecastTableViewCell()
        XCTAssertEqual(cell.dayLabel.text, sut.day)
    }

}
