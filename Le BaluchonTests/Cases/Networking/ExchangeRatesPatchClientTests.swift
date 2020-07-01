//
//  ExchangeRatesClient.swift
//  Le BaluchonTests
//
//  Created by Mahieu Bayon on 08/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

@testable import Le_Baluchon
import XCTest

class ExchangeRatesClientTests: XCTestCase {

    // MARK: - Instance Properties
    var baseURL: URL!
    var mockSession: MockURLSession!
    var sut: ExchangeRatesClient!
    var getRatesURL: URL {
        return URL(string: "latest?access_key=f5131e4adab602e9918159f221aab859&symbols=USD,GBP,JPY,CNY,CAD", relativeTo: baseURL)!
    }
    
    // MARK: - Test Lifecycle
    override func setUp() {
        super.setUp()
        baseURL = URL(string: "https://example.com/api/v1/")!
        mockSession = MockURLSession()
        sut = ExchangeRatesClient(baseURL: baseURL, session: mockSession, responseQueue: nil)
    }

    override func tearDown() {
        baseURL = nil
        mockSession = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Helper methods
    
    func whenGetRates(data: Data? = nil,
                      statusCode: Int = 200,
                      error: Error? = nil)
        -> (calledCompletion: Bool, rates: ExchangeRates?, error: Error?) {

            let response = HTTPURLResponse(url: getRatesURL,
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: nil)
                        
            var calledCompletion = false
            var receivedRates: ExchangeRates? = nil
            var receivedError: Error? = nil
            
            let mockTask = sut.getRates { (rates, error) in
                calledCompletion = true
                receivedRates = rates
                receivedError = error as NSError?
            } as! MockURLSessionDataTask

            mockTask.completionHandler(data, response, error)
            return (calledCompletion, receivedRates, receivedError)

    }
    
    func verifyGetRatesDispatchedToMain(data: Data? = nil,
                                        statusCode: Int = 200,
                                        error: Error? = nil,
                                        line: UInt = #line) {
        // Given
        mockSession.givenDispatchQueue()
        sut = ExchangeRatesClient(baseURL: baseURL,
                                       session: mockSession,
                                       responseQueue: .main)
        
        let expectation = self.expectation(description: "Completion wasn't called")
        
        // When
        var thread: Thread!
        let mockTask = sut.getRates { (rates, error) in
            thread = Thread.current
            expectation.fulfill()
        } as! MockURLSessionDataTask
        
        let response = HTTPURLResponse(url: getRatesURL,
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
        XCTAssertEqual(sut.baseURL, baseURL)
    }
    
    func test_init_sets_Session() {
        XCTAssertEqual(sut.session, mockSession)
    }
    
    func test_init_sets_reponseQueue() {
        // Given
        let response = DispatchQueue.main
        
        // When
        sut = ExchangeRatesClient(baseURL: baseURL,
                                       session: mockSession,
                                       responseQueue: response)
        XCTAssertEqual(sut.responseQueue, response)
    }
    
    // MARK: - ExchangeRatesService - Tests
    func test_conformsTo_ExchangeRatesService() {
        XCTAssertTrue((sut as AnyObject) is ExchangeRatesService)
    }

    func test_exchangeRatesService_declareGetRates() {
        // Given
        let service = sut as ExchangeRatesService
        
        // Then
        _ = service.getRates { _, _ in }
    }
    // MARK: - Shared - Tests
    func test_shared_sets_BaseURL() {
        // Given
        let baseURL = URL(string: "http://data.fixer.io/api/")!
        
        // Then
        XCTAssertEqual(ExchangeRatesClient.shared.baseURL, baseURL)
    }
    
    func test_shared_sets_Session() {
        // Given
        let session = URLSession.shared
        
        // Then
        XCTAssertEqual(ExchangeRatesClient.shared.session, session)
    }
    
    func test_shared_sets_responseQueue() {
        // Given
        let responseQueue = DispatchQueue.main
        
        // Then
        XCTAssertEqual(ExchangeRatesClient.shared.responseQueue, responseQueue)
    }
        
    // MARK: - GetRates - Tests
    func test_getRates_callsExpectedURL() {
        // When
        let mockTask = sut.getRates { (_, _) in
            
        } as! MockURLSessionDataTask
        
        // Then
        XCTAssertEqual(mockTask.url, getRatesURL)
    }
    
    func test_getRates_callsResumOnTask() {
        // When
        let mockTask = sut.getRates { (_, _) in } as! MockURLSessionDataTask
        
        // Then
        XCTAssertTrue(mockTask.calledResume)
    }
    
    func test_getRates_givenResponseStatusCode500_callsCompletion() {
        // When
        let result = whenGetRates(statusCode: 500)
        
        // Then
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.rates)
        XCTAssertNil(result.error)
    }
    
    func test_getRates_givenError_callsCompletionWithError() throws {
        let expectedError = NSError(domain: "com.Le_BaluchonTests", code: 42)
        
        // When
        let result = whenGetRates(error: expectedError)
        
        // Then
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.rates)

        let actualError = try XCTUnwrap(result.error as NSError?)
        XCTAssertEqual(actualError, expectedError)
    }
    
    func test_getRates_givenValidJSON_callsCompletionWithRates() throws {
        // Given
        let data = try Data.fromJSON(fileName: "ExchangeRates")
        
        let decodoer = JSONDecoder()
        let rates = try decodoer.decode(ExchangeRates.self, from: data)
        
        // When
        let result = whenGetRates(data: data)
        
        // Then
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.error)
        XCTAssertEqual(result.rates, rates)
    }
    
    func test_getRates_givenInvalidJSON_callsCompletionWithError() throws {
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
        let result = whenGetRates(data: data)
        
        // Then
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.rates)
       
        let actualError = try XCTUnwrap(result.error as NSError?)
        XCTAssertEqual(actualError.domain, expectedError.domain)
        XCTAssertEqual(actualError.code, expectedError.code)
    }
    
    // MARK: - Queue - Tests
    func test_getRates_givenHTTPStatusError_dispatchesToResponseQueue() {
        verifyGetRatesDispatchedToMain(statusCode: 500)
    }
    
    func test_getRates_givenError_dispatchesToResponseQueue() {
        // Given
        let error = NSError(domain: "com.Le_BaluchonTests", code: 42)

        // Then
        verifyGetRatesDispatchedToMain(error: error)
    }
    
    func test_getRates_givenGoodResponse_dispatchesToResponseQueue() throws {
        // Given
        let data = try Data.fromJSON(fileName: "ExchangeRates")
        
        // Then
        verifyGetRatesDispatchedToMain(data: data)
    }
    
    func test_getRates_givenInvalidResponse_dispatchesToResponseQueue() throws {
        // Given
        let data = try Data.fromJSON(fileName: "GET_ExchangeRates_MissingValuesResponse")
        
        // Then
        verifyGetRatesDispatchedToMain(data: data)
    }
}

class MockURLSession: URLSession {
    var queue: DispatchQueue? = nil
    
    func givenDispatchQueue() {
        queue = DispatchQueue(label: "com.Le_BaluchonTests.MockSession")
    }
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockURLSessionDataTask(completionHandler: completionHandler, url: url, queue: queue)
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    var completionHandler: (Data?, URLResponse?, Error?) -> Void
    var url: URL
    
    init(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void,
         url: URL,
         queue: DispatchQueue?) {
        if let queue = queue {
            self.completionHandler = { data, response, error in
                queue.async {
                    completionHandler(data, response, error)
                }
            }
        } else {
            self.completionHandler = completionHandler
        }
        self.url = url
        super.init()
    }
    
    var calledResume = false
    override func resume() {
        calledResume = true
    }
}
