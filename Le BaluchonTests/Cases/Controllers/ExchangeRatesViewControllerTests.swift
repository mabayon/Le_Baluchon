//
//  ExchangeRatesViewControllerTests.swift
//  Le BaluchonTests
//
//  Created by Mahieu Bayon on 12/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

@testable import Le_Baluchon
import XCTest

class ExchangeRatesViewControllerTests: XCTestCase {

    // MARK: - Instance Properties
    var sut: ExchangeRatesViewController!
    var mockNetworkClient: MockExchangeRatesService!
    
    override func setUp() {
        super.setUp()
        sut = ExchangeRatesViewController.instanceFromStoryboard()
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        mockNetworkClient = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Given
    func givenMockNetworkClient() {
        mockNetworkClient = MockExchangeRatesService()
        sut.networkClient = mockNetworkClient
    }
    
    func givenRates() -> ExchangeRates {
        return ExchangeRates(base: "EUR", date: "2020-06-09", rates: ["USD": 1.12972])
    
    }

    // MARK: - Instance Properties - Tests
    func test_networkClient_setToExchangeRatesClient() {
        XCTAssertTrue((sut.networkClient as? ExchangeRatesClient) === ExchangeRatesClient.shared)
    }
    
    func test_refreshData_sets_request() {
        // Given
        givenMockNetworkClient()
        
        // When
        sut.refreshData()
        
        // Then
        XCTAssertEqual(sut.dataTask, mockNetworkClient.getRatesDataTask)
    }
    
    func test_refreshData_ifAlreadyRefreshing_doesntCallAgain() {
        // Given
        givenMockNetworkClient()

        // When
        sut.refreshData()
        sut.refreshData()

        // Then
        XCTAssertEqual(mockNetworkClient.getRatesCallCount, 1)
    }
    
    func test_refreshData_completionNilsDataTask() {
        // Given
        givenMockNetworkClient()
        let rates = givenRates()
        
        // When
        sut.refreshData()
        mockNetworkClient.getRatesCompletion(rates, nil)
        
        // Then
        XCTAssertNil(sut.dataTask)
    }
    
    func test_refreshData_givenRatesResponse_setsViewModel() {
        // Given
        givenMockNetworkClient()
        let rates = givenRates()
        let viewModels = ExchangeRatesViewModel(exchangeRates: rates)
        
        // When
        sut.refreshData()
        mockNetworkClient.getRatesCompletion(rates, nil)

        XCTAssertEqual(sut.viewModels, viewModels)
    }
    
}
