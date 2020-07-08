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
    
    var apiServices: APIService = .Fixer {
        didSet {
            sut = NetworkClients(apiURL: apiURL, session: mockSession, responseQueue: nil, apiServices: apiServices)
        }
    }
    
    var getFixerURL: URL {
        return URL(string: Fixer.url)!
    }

    var getOpenWeatherURL: URL {
        return URL(string: OpenWeather.urlCurrentWeather)!
    }

    // MARK: - Test Lifecycle
    override func setUp() {
        super.setUp()
        apiURL = Fixer.url
        mockSession = MockURLSession()
        apiServices = .Fixer
    }

    override func tearDown() {
        apiURL = nil
        mockSession = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Helper methods
    
    func whenGetData(for url: URL,
                     data: Data? = nil,
                      statusCode: Int = 200,
                      error: Error? = nil)
        -> (calledCompletion: Bool, data: Any?, error: Error?) {

            let response = HTTPURLResponse(url: getFixerURL,
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: nil)
                        
            var calledCompletion = false
            var receivedData: Any? = nil
            var receivedError: Error? = nil
            
            let mockTask = sut.getData { (data, error) in
                calledCompletion = true
                receivedData = data
                receivedError = error as NSError?
            } as! MockURLSessionDataTask

            mockTask.completionHandler(data, response, error)
            return (calledCompletion, receivedData, receivedError)

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
    
    // MARK: - NetworkClientsService - Tests
    func test_conformsTo_NetworkClientsService() {
        XCTAssertTrue((sut as AnyObject) is NetworkClientsService)
    }

    func test_networkClientsService_declareGetData() {
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
        let result = whenGetData(for: getFixerURL, statusCode: 500)
        
        // Then
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.data)
        XCTAssertNil(result.error)
    }
    
    func test_getData_givenError_callsCompletionWithError() throws {
        let expectedError = NSError(domain: "com.Le_BaluchonTests", code: 42)
        
        // When
        let result = whenGetData(for: getFixerURL, error: expectedError)
        
        // Then
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.data)

        let actualError = try XCTUnwrap(result.error as NSError?)
        XCTAssertEqual(actualError, expectedError)
    }
    
    func test_getData_givenValidJSON_callsCompletionWithRates() throws {
        // Given
        let data = try Data.fromJSON(fileName: "ExchangeRates")
        
        let decodoer = JSONDecoder()
        let rates = try decodoer.decode(ExchangeRates.self, from: data)
        
        // When
        let result = whenGetData(for: getFixerURL, data: data)
        
        // Then
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.error)
        XCTAssertEqual((result.data as? ExchangeRates), rates)
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
        let result = whenGetData(for: getFixerURL, data: data)
        
        // Then
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.data)
       
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

// MARK: - OpenWeather - Tests
extension NetworkClientsTests {
    
    func test_getData_givenValidJSON_callsCompletionWithTodayWeather() throws {
        // Given
        OpenWeather.latitude = "48.8534"
        OpenWeather.longitude = "2.3488"
        apiServices = .OpenWeatherCurrent
        let data = try Data.fromJSON(fileName: "TodayWeather")
        
        let decodoer = JSONDecoder()
        let weather = try decodoer.decode(TodayWeather.self, from: data)
        
        // When
        let result = whenGetData(for: getOpenWeatherURL, data: data)
        
        // Then
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.error)
        XCTAssertEqual((result.data as? TodayWeather), weather)
    }

}
