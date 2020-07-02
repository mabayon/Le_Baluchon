//
//  MockExchangeRatesService.swift
//  Le BaluchonTests
//
//  Created by Mahieu Bayon on 12/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

@testable import Le_Baluchon
import Foundation

class MockNetworkClientsService: NetworkClientsService {
    var getRatesCallCount = 0
    var getRatesDataTask = URLSessionDataTask()
    var getRatesCompletion: ((ExchangeRates?, Error?) -> Void)!
    
    func getData(completion: @escaping (Any?, Error?) -> Void) -> URLSessionDataTask {
        getRatesCallCount += 1
        getRatesCompletion = completion
        return getRatesDataTask
    }
}
