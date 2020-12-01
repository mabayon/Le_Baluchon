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
    var mockNetworkClient: MockNetworkClientsService!
    
    override func setUp() {
        super.setUp()
        sut = ExchangeRatesViewController.instanceFromStoryboard()
        sut.loadView()
    }
    
    override func tearDown() {
        mockNetworkClient = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Given
    
    func givenViewModel() {
        sut.viewModel = ExchangeRatesViewModel(exchangeRates: givenRates())
    }
    
    func givenMockViewModel() {
        sut.viewModel = MockExchangeRatesViewModel(exchangeRates: givenRates())
    }
    
    func givenMockNetworkClient() {
        mockNetworkClient = MockNetworkClientsService()
        sut.networkClient = mockNetworkClient
    }
    
    func givenRates() -> ExchangeRates {
        return ExchangeRates(base: "EUR", date: "2020-06-09", rates: ["USD": 1.12972])
        
    }
    
    // MARK: - When
    func whenDequeueCollectionViewCells() -> [UICollectionViewCell] {
        return (0 ..< (sut.viewModel?.currencies.count)! - 1).map { i in
            let indexPath = IndexPath(row: i, section: 0)
            return sut.collectionView(sut.collectionView, cellForItemAt: indexPath)
        }
    }
    
    // MARK: - Instance Properties - Tests
    func test_networkClient_setToExchangeRatesClient() {
        XCTAssertTrue((sut.networkClient as! NetworkClients) === NetworkClients.fixer)
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
        let viewModel = ExchangeRatesViewModel(exchangeRates: rates)
        
        // When
        sut.refreshData()
        mockNetworkClient.getRatesCompletion(rates, nil)
        
        XCTAssertEqual(sut.viewModel, viewModel)
    }
    
    // MARK: Refresh Control - Tests
    
    func test_refreshData_beginsRefreshing() {
      // given
      givenMockNetworkClient()

      // when
      sut.refreshData()

      // then
      XCTAssertTrue(sut.refreshControl.isRefreshing)
    }

    func test_refreshData_givenDogsResponse_endsRefreshing() {
      // given
      givenMockNetworkClient()
      let rates = givenRates()

      // when
      sut.refreshData()
      mockNetworkClient.getRatesCompletion(rates, nil)

      // then
      XCTAssertFalse(sut.refreshControl.isRefreshing)
    }

    
    // MARK: UICollectionViewDataSource - Tests
    func test_collectionView_numberOfRowsInSection_returns0() {
        // given
        let expected = 0
        
        // when
        let actual = sut.collectionView(sut.collectionView, numberOfItemsInSection: 0)
        
        // then
        XCTAssertEqual(actual, expected)
    }
    
    func test_collectionViewCellForItemAt_givenViewModelsSet_returnsCountryCollectionViewCells() {
        // given
        givenViewModel()
        
        // when
        let cells = whenDequeueCollectionViewCells()
        
        // then
        for cell in cells {
            XCTAssertTrue(cell is CountryCollectionViewCell)
        }
    }
    
    func test_collectionViewCellForItemAt_givenViewModelSet_configuresCollectionViewCells() throws {
        // given
        givenMockViewModel()
        
        // when
        let cells = try XCTUnwrap(whenDequeueCollectionViewCells() as? [CountryCollectionViewCell])
        
        // then
        for i in 0 ..< (sut.viewModel?.currencies.count)! - 1 {
            let cell = cells[i]
            let viewModel = sut.viewModel as! MockExchangeRatesViewModel
            XCTAssertTrue(viewModel.configuredCell === cell) // pointer equality
        }
    }
}

// MARK: - Mocks
extension ExchangeRatesViewControllerTests {
    
    class MockExchangeRatesViewModel: ExchangeRatesViewModel {
        var configuredCell: CountryCollectionViewCell?
        override func configureCell(_ cell: CountryCollectionViewCell, for row: Int) {
            self.configuredCell = cell
        }
    }
}
