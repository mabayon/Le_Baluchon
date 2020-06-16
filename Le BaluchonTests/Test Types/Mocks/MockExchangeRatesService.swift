//
//  MockExchangeRatesService.swift
//  Le BaluchonTests
//
//  Created by Mahieu Bayon on 12/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

@testable import Le_Baluchon
import Foundation

class MockExchangeRatesService: ExchangeRatesService {
    var getRatesCallCount = 0
    var getRatesDataTask = URLSessionDataTask()
    var getRatesCompletion: ((ExchangeRates?, Error?) -> Void)!
    
    func getRates(completion: @escaping (ExchangeRates?, Error?) -> Void) -> URLSessionDataTask {
        getRatesCallCount += 1
        getRatesCompletion = completion
        return getRatesDataTask
    }
}
