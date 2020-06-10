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
    
    func test_initExchangeRates_givenBaseEUR_setsDeviseBase() {
        // When
        whenSUTSetFromExchangeRates(base: "EUR")
        
        // Then
        XCTAssertEqual(sut.deviseBase, Devise(name: "EUR", value: 1, image: UIImage(named: "EUR")!))
    }
    
    func test_initExchangeRates_givenRatesUSD_setsDevisesRates() {
        // Given
        whenSUTSetFromExchangeRates(rates: ["USD": 1.12972])

        // Then
        XCTAssertEqual(sut.devisesRates, [Devise(name: "USD", value: 1.12972, image: UIImage(named: "USD")!)])
    }
    
    func test_initExchangeRates_givenUnknownDeviseImage_setDevisesRates() {
        // Given
        whenSUTSetFromExchangeRates(rates: ["AUD": 1.12972])

        // Then
        XCTAssertEqual(sut.devisesRates, [Devise(name: "AUD", value: 1.12972, image: UIImage())])
    }
    
    // MUST BE CHANGED WHEN THERE ARE MORE DEVISES
    func test_initExchangeRates_givenRatesUSD_EUR_setsDevisesRates() {
        // Given
        whenSUTSetFromExchangeRates(rates: ["USD": 1.12972, "EUR": 1.256333])

        // Then
        let expectedDevises = [Devise(name: "USD", value: 1.12972, image: UIImage(named: "USD")!),
                               Devise(name: "EUR", value: 1.256333, image: UIImage(named: "EUR")!)]
        
        XCTAssertEqual(sut.devisesRates.sorted { $0.name < $1.name },
                       expectedDevises.sorted { $0.name < $1.name })
    }
        
//    func test_initExchangeRates_givenLastUpdate1YearAgo_setLastUpdate() {
//        // Given
//        whenSUTSetFromExchangeRates(timestamp: 1.year.pastDate)
//
//        // Then
//        XCTAssertEqual(sut.lastUpdate, "Il y a 1 an")
//    }
//
//    func test_initExchangeRates_givenLastUpdate2YearsAgo_setLastUpdate() {
//        // Given
//        whenSUTSetFromExchangeRates(timestamp: 2.years.pastDate)
//
//        // Then
//        XCTAssertEqual(sut.lastUpdate, "Il y a 2 ans")
//    }
//
//    func test_initExchangeRates_givenLastUpdate1MonthAgo_setLastUpdate() {
//        // Given
//        whenSUTSetFromExchangeRates(timestamp: 1.month.pastDate)
//
//        // Then
//        XCTAssertEqual(sut.lastUpdate, "Il y a 1 mois")
//    }
//
//    func test_initExchangeRates_givenLastUpdate2MonthsAgo_setLastUpdate() {
//        // Given
//        whenSUTSetFromExchangeRates(timestamp: 2.months.pastDate)
//
//        // Then
//        XCTAssertEqual(sut.lastUpdate, "Il y a 2 mois")
//    }
//
//    func test_initExchangeRates_givenLastUpdate1WeekAgo_setLastUpdate() {
//        // Given
//        whenSUTSetFromExchangeRates(timestamp: 1.week.pastDate)
//
//        // Then
//        XCTAssertEqual(sut.lastUpdate, "Il y a 1 semaine")
//    }
//
//    func test_initExchangeRates_givenLastUpdate2WeeksAgo_setLastUpdate() {
//        // Given
//        whenSUTSetFromExchangeRates(timestamp: 2.weeks.pastDate)
//
//        // Then
//        XCTAssertEqual(sut.lastUpdate, "Il y a 2 semaines")
//    }
//
//    func test_initExchangeRates_givenLastUpdate1DayAgo_setLastUpdate() {
//        // Given
//        whenSUTSetFromExchangeRates(timestamp: 1.day.pastDate)
//
//        // Then
//        XCTAssertEqual(sut.lastUpdate, "Il y a 1 jour")
//    }
//
//    func test_initExchangeRates_givenLastUpdate2DaysAgo_setLastUpdate() {
//        // Given
//        whenSUTSetFromExchangeRates(timestamp: 2.days.pastDate)
//
//        // Then
//        XCTAssertEqual(sut.lastUpdate, "Il y a 2 jours")
//    }
//
//    func test_initExchangeRates_givenLastUpdate1HourAgo_setLastUpdate() {
//        // Given
//        whenSUTSetFromExchangeRates(timestamp: 1.hour.pastDate)
//
//        // Then
//        XCTAssertEqual(sut.lastUpdate, "Il y a 1 heure")
//    }
//
//    func test_initExchangeRates_givenLastUpdate2HoursAgo_setLastUpdate() {
//        // Given
//        whenSUTSetFromExchangeRates(timestamp: 2.hours.pastDate)
//
//        // Then
//        XCTAssertEqual(sut.lastUpdate, "Il y a 2 heures")
//    }
//
//    func test_initExchangeRates_givenLastUpdate1MinuteAgo_setLastUpdate() {
//        // Given
//        whenSUTSetFromExchangeRates(timestamp: 1.minute.pastDate)
//
//        // Then
//        XCTAssertEqual(sut.lastUpdate, "Il y a 1 minute")
//    }
//
//    func test_initExchangeRates_givenLastUpdate2MinutesAgo_setLastUpdate() {
//        // Given
//        whenSUTSetFromExchangeRates(timestamp: 2.minutes.pastDate)
//
//        // Then
//        XCTAssertEqual(sut.lastUpdate, "Il y a 2 minutes")
//    }
//
//    func test_initExchangeRates_givenLastUpdate1SecondAgo_setLastUpdate() {
//        // Given
//        whenSUTSetFromExchangeRates(timestamp: 1.second.pastDate)
//
//        // Then
//        XCTAssertEqual(sut.lastUpdate, "Il y a 1 seconde")
//    }
}
