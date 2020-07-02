//
//  NetworkClientsTests.swift
//  Le BaluchonTests
//
//  Created by Mahieu Bayon on 02/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

@testable import Le_Baluchon
import XCTest

class NetworkClientsTests: XCTestCase {

    // MARK: - Instance Properties
    var apiURL: String!
    var mockSession: MockURLSession!
    var sut: NetworkClients!
    var getFixerURL: URL {
        return URL(string: Fixer.url)!
    }

    // MARK: - Test Lifecycle
    override func setUp() {
        super.setUp()
        apiURL = Fixer.url
        mockSession = MockURLSession()
        sut = NetworkClients(apiURL: apiURL, session: mockSession, responseQueue: nil, apiServices: .Fixer)
    }

    override func tearDown() {
        apiURL = nil
        mockSession = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Helper methods
    
    func whengetData(data: Data? = nil,
                      statusCode: Int = 200,
                      error: Error? = nil)
        -> (calledCompletion: Bool, rates: ExchangeRates?, error: Error?) {

            let response = HTTPURLResponse(url: getFixerURL,
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: nil)
                        
            var calledCompletion = false
            var receivedRates: ExchangeRates? = nil
            var receivedError: Error? = nil
            
            let mockTask = sut.getData { (rates, error) in
                calledCompletion = true
                receivedRates = rates as? ExchangeRates
                receivedError = error as NSError?
            } as! MockURLSessionDataTask

            mockTask.completionHandler(data, response, error)
            return (calledCompletion, receivedRates, receivedError)

    }
    
    func verifygetDataDispatchedToMain(data: Data? = nil,
                                        statusCode: Int = 200,
                                        error: Error? = nil,
                                        line: UInt = #line) {
        // Given
        mockSession.givenDispatchQueue()
        sut = NetworkClients(apiURL: apiURL,
                                       session: mockSession,
                                       responseQueue: .main,
                                       apiServices: .Fixer)
        
        let expectation = self.expectation(description: "Completion wasn't called")
        
        // When
        var thread: Thread!
        let mockTask = sut.getData { (rates, error) in
            thread = Thread.current
            expectation.fulfill()
        } as! MockURLSessionDataTask
        
        let response = HTTPURLResponse(url: getFixerURL,
                                       statusCode: statusCode,
                                       httpVersion: nil,
                                       headerFields: nil)
        mockTask.completionHandler(data, response, error)
        
        // Then
        waitForExpectations(timeout: 0.2) { _ in
            XCTAssertTrue(thread.isMainThread, line: line)
        }

    }
    // MARK: - Init - Tests
    func test_init_sets_BaseURL() {
        XCTAssertEqual(sut.apiURL, apiURL)
    }
    
    func test_init_sets_Session() {
        XCTAssertEqual(sut.session, mockSession)
    }
    
    func test_init_sets_reponseQueue() {
        // Given
        let response = DispatchQueue.main
        
        // When
        sut = NetworkClients(apiURL: apiURL,
                                       session: mockSession,
                                       responseQueue: response,
                                       apiServices: .Fixer)
        XCTAssertEqual(sut.responseQueue, response)
    }
    
    // MARK: - ExchangeRatesService - Tests
    func test_conformsTo_ExchangeRatesService() {
        XCTAssertTrue((sut as AnyObject) is NetworkClientsService)
    }

    func test_exchangeRatesService_declaregetData() {
        // Given
        let service = sut as NetworkClientsService
        
        // Then
        _ = service.getData { _, _ in }
    }
    // MARK: - Shared - Tests
    func test_shared_sets_BaseURL() {
        // Given
        let apiURL = "http://data.fixer.io/api/latest?access_key=f5131e4adab602e9918159f221aab859&symbols=USD,GBP,JPY,CNY,CAD"
        
        // Then
        XCTAssertEqual(NetworkClients.fixer.apiURL, apiURL)
    }
    
    func test_shared_sets_Session() {
        // Given
        let session = URLSession.shared
        
        // Then
        XCTAssertEqual(NetworkClients.fixer.session, session)
    }
    
    func test_shared_sets_responseQueue() {
        // Given
        let responseQueue = DispatchQueue.main
        
        // Then
        XCTAssertEqual(NetworkClients.fixer.responseQueue, responseQueue)
    }
        
    // MARK: - getData - Tests
    func test_getData_callsExpectedURL() {
        // When
        let mockTask = sut.getData { (_, _) in
            
        } as! MockURLSessionDataTask
        
        // Then
        XCTAssertEqual(mockTask.url, getFixerURL)
    }
    
    func test_getData_callsResumOnTask() {
        // When
        let mockTask = sut.getData { (_, _) in } as! MockURLSessionDataTask
        
        // Then
        XCTAssertTrue(mockTask.calledResume)
    }
    
    func test_getData_givenResponseStatusCode500_callsCompletion() {
        // When
        let result = whengetData(statusCode: 500)
        
        // Then
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.rates)
        XCTAssertNil(result.error)
    }
    
    func test_getData_givenError_callsCompletionWithError() throws {
        let expectedError = NSError(domain: "com.Le_BaluchonTests", code: 42)
        
        // When
        let result = whengetData(error: expectedError)
        
        // Then
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.rates)

        let actualError = try XCTUnwrap(result.error as NSError?)
        XCTAssertEqual(actualError, expectedError)
    }
    
    func test_getData_givenValidJSON_callsCompletionWithRates() throws {
        // Given
        let data = try Data.fromJSON(fileName: "ExchangeRates")
        
        let decodoer = JSONDecoder()
        let rates = try decodoer.decode(ExchangeRates.self, from: data)
        
        // When
        let result = whengetData(data: data)
        
        // Then
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.error)
        XCTAssertEqual(result.rates, rates)
    }
    
    func test_getData_givenInvalidJSON_callsCompletionWithError() throws {
        // Given
        let data = try Data.fromJSON(fileName: "GET_ExchangeRates_MissingValuesResponse")
        
        var expectedError: NSError!
        let decoder = JSONDecoder()
      
        do {
            _ = try decoder.decode(ExchangeRates.self, from: data)
        } catch {
            expectedError = error as NSError
        }
        
        // When
        let result = whengetData(data: data)
        
        // Then
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.rates)
       
        let actualError = try XCTUnwrap(result.error as NSError?)
        XCTAssertEqual(actualError.domain, expectedError.domain)
        XCTAssertEqual(actualError.code, expectedError.code)
    }
    
    // MARK: - Queue - Tests
    func test_getData_givenHTTPStatusError_dispatchesToResponseQueue() {
        verifygetDataDispatchedToMain(statusCode: 500)
    }
    
    func test_getData_givenError_dispatchesToResponseQueue() {
        // Given
        let error = NSError(domain: "com.Le_BaluchonTests", code: 42)

        // Then
        verifygetDataDispatchedToMain(error: error)
    }
    
    func test_getData_givenGoodResponse_dispatchesToResponseQueue() throws {
        // Given
        let data = try Data.fromJSON(fileName: "ExchangeRates")
        
        // Then
        verifygetDataDispatchedToMain(data: data)
    }
    
    func test_getData_givenInvalidResponse_dispatchesToResponseQueue() throws {
        // Given
        let data = try Data.fromJSON(fileName: "GET_ExchangeRates_MissingValuesResponse")
        
        // Then
        verifygetDataDispatchedToMain(data: data)
    }
}
